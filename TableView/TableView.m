//
//  TableView.m
//  TableView
//
//  Created by 李鹏跃 on 2018/9/13.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "TableView.h"
@interface TableView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@end

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setup];
    }
    return self;
}

- (void)setup {

    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor = randomRGBColor;
    UIView *view = [cell viewWithTag:111];
    if (view) return cell;
    
    UIButton *button = [[UIButton alloc]init];
    button.tag = indexPath.row + 1;
    [cell.contentView addSubview:button];
    button.frame = cell.bounds;
    [button setTitle:[NSString stringWithFormat:@"%@",indexPath] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)click: (UIButton*)button   {
    NSLog(@"点击了第 %ld 个cell",(button.tag - 1));
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrolling];
}

@end
