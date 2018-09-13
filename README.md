![SpringTableView.gif](https://upload-images.jianshu.io/upload_images/4185621-38b470f2a37c57c9.gif?imageMogr2/auto-orient/strip)


[demo 下载](https://github.com/LiPengYue/SpringTableView.git)

## 1. 思路
1. 添加给tableView添加一个子view headerView
2. 调整headerView zPosition 使其z坐标在tableView的最底部
3. 当tableView 滑动，cell挡住headerView的时候，需要调整headerView的事件相应热区

## 2. 代码
**1. 设置headerView的zPosition：**
> zPosition就是z轴，它的坐标标度从屏幕内往屏幕外依次递增；
```
NSInteger zPosition = self.isCoverOnCell ? NSUIntegerMax : -1;     
_headerView.layer.zPosition = zPosition;
```
**2. 调整tableView 的contentInsert**
> 需要保证tableView的顶部露出headerView
```
 CGFloat top = self.contentInset.top;
        if (CGRectGetMaxY(self.headerViewFrame) < self.bottomHoverY) {
            top -= self.bottomHoverY;
        }else{
            top -= CGRectGetMaxY(self.headerViewFrame);
        }
        self.headerViewFrame = self.headerView.frame;
        top += CGRectGetMaxY(self.headerViewFrame);
        
        CGFloat bottom = self.contentInset.bottom;
        self.contentInset = UIEdgeInsetsMake(top, 0, 0, bottom);
```
**3. tableView滚动的时候需要设置headerView的可点击范围**
· 传入热区 范围 属性并依此判断是否应该响应事件
```
@property (nonatomic,assign) CGRect responseFrame;
```
· headerView 点击热区需要重写HeaderView的 `pointInside：withEvent：`方法
```
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ((self.responseFrame.size.height <= 0)
        || (self.responseFrame.size.width <= 0)) {
        return false;
    }
    CGFloat minX1 = CGRectGetMinX(self.frame);
    CGFloat minY1 = CGRectGetMinY(self.frame);
    CGFloat minW1 = CGRectGetWidth(self.frame);
    CGFloat minH1 = CGRectGetHeight(self.frame);

    CGFloat minX2 = CGRectGetMinX(self.responseFrame);
    CGFloat minY2 = CGRectGetMinY(self.responseFrame);
    CGFloat minW2 = CGRectGetWidth(self.responseFrame);
    CGFloat minH2 = CGRectGetHeight(self.responseFrame);
    
    CGFloat minX = minX1 < minX2 ? minX1 : minX2;
    CGFloat minY = minY1 < minY2 ? minX1 : minY2;
    CGFloat minW = minW1 < minW2 ? minW1 : minW2;
    CGFloat minH = minH1 < minH2 ? minH1 : minH2;
    CGRect rect = CGRectMake(minX, minY, minW, minH);
    
    return CGRectContainsPoint(rect, point);
}
```

**4. 添加pan手势监听**
> 根据pan手势的状态来执行动画
```
 [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
```
```

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"panGestureRecognizer.state"]) {
        CGPoint contentOffset = self.contentOffset;
        switch (self.panGestureRecognizer.state) {
                
            case UIGestureRecognizerStatePossible:
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
                return;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
                break;
        }
        if (self.animationBlock) {
            self.animationBlock(self, self.contentOffset);
            return;
        }
        
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        CGFloat animationY = 0;
        //        NSLog(@"%@",NSStringFromCGPoint(contentOffset));
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatAutoreverses:false];
        if (contentOffset.y > 0) {
            return;
        }
        if (contentOffset.y > -self.headerView.frame.size.height){
            [UIView commitAnimations];
            animationY = -self.midHoverY;
            [self setContentOffset:self.contentOffset animated:false];
        }else{
            animationY = -self.bottomHoverY;
        }
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [self setContentOffset:CGPointMake(0, animationY) animated:false];
            
        } completion:^(BOOL finished) {
        }];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
```
### 5  动画自定义：
```
/**
 * @brief 松手之后执行需要的动画
 * @warning 警告: 如果实现这个方法，则不会执行默认动画
 */
- (void) customAnimationFunc: (void(^)(SpringTableView *view,CGPoint contentOffset)) block;
```

## 3. 坑
1. 需要在父控件的`- (void)dealloc`方法中调用 `reless`方法,否则会产生内存泄露`（主要是移除了观察者）`
2. 如果对`tableVIew.delegate `进行了赋值，那么需要在scrollViewDidScroll: 代理方法中调用 scrolling 方法`（内部 协调了headerView的点击热区）`
3. 如果实现了`customAnimationFunc：`方法，则会覆盖默认动画

[demo 下载](https://github.com/LiPengYue/SpringTableView.git)
