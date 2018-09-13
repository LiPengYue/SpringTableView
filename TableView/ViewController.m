//
//  ViewController.m
//  TableView
//
//  Created by 李鹏跃 on 2018/9/12.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "TableView.h"
#import "SpringTableViewHeaderView.h"

@interface ViewController () 
@property (nonatomic,strong) TableView *tableView;
@property (nonatomic,strong) SpringTableViewHeaderView *headerView;
@property (nonatomic,strong) UIDynamicAnimator *dynamic;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView = [[SpringTableViewHeaderView alloc] init];
     self.tableView = [[TableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self setupTableView];
    [self setUpHeaderView];
    [self.tableView adjustHeaderView];
    self.tableView.midHoverY = 150;
    self.tableView.bottomHoverY = 200;
}


- (void)setUpHeaderView {
    self.headerView.layer.zPosition = -1;
    self.headerView.backgroundColor = randomRGBColor;

    CGRect rect = self.view.frame;
    rect.size.height = 200;
    self.headerView.frame = rect;
    UIButton *button = [[UIButton alloc]init];
    button.frame = rect;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.headerView addSubview:button];
    
}

- (void) setupTableView {
    [self.view addSubview:self.tableView];
    self.tableView.headerView = self.headerView;
   
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    } else {
    }
}

- (void)click {
    NSLog(@"点击了headerView");
}
@end
