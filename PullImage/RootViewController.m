//
//  RootViewController.m
//  PullImage
//
//  Created by aDu on 2017/7/4.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "RootCell.h"

#define K_Cell @"cell"
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface RootViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) float imgHeight;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下拉放大";
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取图片在APP显示的高度
    UIImage *img = [UIImage imageNamed:@"girl"];
    self.imgHeight = (K_Width / img.size.width) * img.size.height;
    
    self.imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, -_imgHeight, self.view.frame.size.width, _imgHeight))];
    _imageView.image = [UIImage imageNamed:@"girl"];
    //关键： 照片按照自己的比例填充满
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    //关键： 超出 imageView部分裁减掉
    _imageView.clipsToBounds = YES;
    [self.tableView addSubview:self.imageView];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootCell *cell = [tableView dequeueReusableCellWithIdentifier:K_Cell forIndexPath:indexPath];
    return cell;
}

#pragma mark ========== UIScrollViewDelegate ==========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 向下的话 为负数
    CGFloat offY = scrollView.contentOffset.y;
    NSLog(@"%lf<>%lf", offY, _imgHeight);
    // 下拉超过照片的高度的时候
    if (offY < -_imgHeight) {
        CGRect frame = self.imageView.frame;
        // 这里的思路就是改变 顶部的照片的 fram
        self.imageView.frame = CGRectMake(0, offY, frame.size.width, -offY);
    } else {
        self.imageView.frame = CGRectMake(0, offY, K_Width, _imgHeight);
    }
}

#pragma mark ========== init ==========
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"RootCell" bundle:nil] forCellReuseIdentifier:K_Cell];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(self.imgHeight - 20, 0, 0, 0);
    }
    return _tableView;
}

@end
