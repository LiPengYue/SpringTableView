//
//  TableView.m
//  TableView
//
//  Created by 李鹏跃 on 2018/9/12.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "SpringTableView.h"


@interface SpringTableView ()
<
UITableViewDelegate
>
@property (nonatomic,assign) CGRect headerViewFrame;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,assign) BOOL isReLayout;
@property (nonatomic,copy) void(^animationBlock)(SpringTableView *view,CGPoint contentOffset);
@end

@implementation SpringTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView {
    self.isReLayout = true;
    self.delegate = self;
   
    [self addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - functions
- (void) adjustHeaderView {
    self.isReLayout = true;
    NSInteger zPosition = self.isCoverOnCell ? NSUIntegerMax : -1;
    _headerView.layer.zPosition = zPosition;
    [self layoutSubviews];
}

- (void)reless {
    [self removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
}

- (void) customAnimationFunc: (void(^)(SpringTableView *view,CGPoint contentOffset)) block {
    _animationBlock = block;
}


// MARK: properties get && set
- (void) setHeaderView:(SpringTableViewHeaderView *)headerView {
    _headerView = headerView;
    [self addSubview: _headerView];
    self.headerViewFrame = headerView.frame;
    [self adjustHeaderView];
}


// MARK:life cycles
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isReLayout) {
        self.isReLayout = false;
        
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
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrolling];
}

-(void) scrolling {
    if (self.contentSize.height < self.frame.size.height - self.midHoverY) {
        self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height - self.midHoverY);
    }

    CGRect rect = self.headerViewFrame;
    rect.origin.y = self.contentOffset.y;
    self.headerView.frame = rect;
    
    CGFloat h =  -self.contentOffset.y;
    h = h < 0 ? 0 : h;
    self.headerView.responseFrame = CGRectMake(0, 0, rect.size.width, h);
}

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
- (void)dealloc
{
    <#statements#>
}

@end



