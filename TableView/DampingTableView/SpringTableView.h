//
//  TableView.h
//  TableView
//
//  Created by 李鹏跃 on 2018/9/12.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringTableViewHeaderView.h"
#define randomRGBColor RGBCOLOR(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]


@interface SpringTableView : UITableView
/// 顶部不做弹簧动画的view
@property (nonatomic,strong) SpringTableViewHeaderView *headerView;
/// headerView 是否被cell覆盖 如果超过了header的maxY
@property (nonatomic,assign) BOOL isCoverOnCell;

/// 中间悬停 y 自定义动画后，将无效
@property (nonatomic,assign) CGFloat midHoverY;

/// 底部的悬停 y 自定义动画后，将无效
@property (nonatomic,assign) CGFloat bottomHoverY;

/// header view 的frame发生变化后需要调用这个方法刷新UI
- (void) adjustHeaderView;

/**
 * @brief 释放对象 内部监听了pan手势的 state，需要移除观察者
 *
 * @bug 缺陷: 需要在self的持有类的deinit方法中调用这个方法 否则将会崩溃
 */
- (void) reless;



/**
 * @brief 松手之后执行需要的动画
 * 内部 协调了headerView的点击热区
 * @warning 警告: 如果对self.delegate 进行了赋值，那么需要在scrollViewDidScroll: 代理方法中调用 scrolling 方法
 */
-(void) scrolling;

#pragma mark - 动画 自定义
/**
 * @brief 松手之后执行需要的动画
 * @warning 警告: 如果实现这个方法，则不会执行默认动画
 */
- (void) customAnimationFunc: (void(^)(SpringTableView *view,CGPoint contentOffset)) block;
@end
