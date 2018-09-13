//
//  DampingTableHeaderView.m
//  TableView
//
//  Created by 李鹏跃 on 2018/9/13.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "SpringTableViewHeaderView.h"
@interface SpringTableViewHeaderView()

@end
@implementation SpringTableViewHeaderView
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
@end
