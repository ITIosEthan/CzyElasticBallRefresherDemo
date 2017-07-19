//
//  ViewController.m
//  CzyElasticBallRefresher
//
//  Created by macOfEthan on 17/7/18.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "CzyElasticBallRefresherView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) UITableView *tableView;

@property (nonatomic, copy) CzyElasticBallRefresherView *ballRefreshView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self simpleTableViewInit];
    
    _ballRefreshView = [[CzyElasticBallRefresherView alloc] initWithFrame:CGRectMake(0, -50, kFullWidth, 50)];
    [self.view addSubview:_ballRefreshView];
}

- (void)simpleTableViewInit
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reusedId = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld,row:%ld", indexPath.section, indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffSetY = scrollView.contentOffset.y;
    
    if (contentOffSetY > -50) {
        return;
    }

    _ballRefreshView.contentOffSetY = contentOffSetY;
    
    _ballRefreshView.frame = CGRectMake(0, 0, kFullWidth, 50);
    [_tableView setContentInset:UIEdgeInsetsMake(50, 0, 0, 0)];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffSetY = scrollView.contentOffset.y;
    
    CGFloat y;
    if (contentOffSetY < -50) {
        
        scrollView.scrollEnabled = NO;
        
        y = 50;
        _ballRefreshView.frame = CGRectMake(0, 0, kFullWidth, y);
        [_tableView setContentInset:UIEdgeInsetsMake(y, 0, 0, 0)];
        
        [_ballRefreshView startRotatiton];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                _ballRefreshView.frame = CGRectMake(0, -50, kFullWidth, 50);
                [_ballRefreshView stopRotation];
                [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                scrollView.scrollEnabled = YES;
            }];
        });
    }
}


@end
