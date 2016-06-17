//
//  MoreViewController.m
//  nRF Toolbox
//
//  Created by SINOWINNER on 16/5/9.
//  Copyright © 2016年 Nordic Semiconductor. All rights reserved.
//

#import "MoreViewController.h"
#import "ZHCYJHomeButtomViewCell.h"

@interface MoreViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation MoreViewController

static NSString *const identifier = @"homeButtomCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[NSLocalizedString(@"个人资料", nil),NSLocalizedString(@"修改密码", nil),NSLocalizedString(@"积分", nil),NSLocalizedString(@"设置", nil),@"",@""];
    self.imageArray = @[@"userinfo",@"password",@"integral",@"setting",@"",@""];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    self.title = NSLocalizedString(@"我", nil);

    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setTitleColor:[UIColor colorWithRed:1.000 green:0.163 blue:0.656 alpha:1.000] forState:UIControlStateNormal];
    [self.view addSubview:add];
    
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.width.equalTo(self.view.mas_width).multipliedBy((0.3333));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"addbaby"];
    [add addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = NSLocalizedString(@"添加宝宝", nil);
    label.textColor = [UIColor colorWithRed:1.000 green:0.163 blue:0.656 alpha:1.000];
    [add addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(add.mas_centerX);
        make.centerY.equalTo(add.mas_centerY).offset(-20);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(add.mas_centerX);
        make.centerY.equalTo(add.mas_centerY).offset(20);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundView = nil;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ZHCYJHomeButtomViewCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(add.mas_bottom);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.67);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHCYJHomeButtomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *text = _dataArray[indexPath.item];
    NSString *image = _imageArray[indexPath.item];
    cell.buttonLabel.text = text;
    cell.buttonImage.image = [UIImage imageNamed:image];
    [cell.button setBackgroundImage:[UIImage imageNamed:@"home_btn_bg_r_t"] forState:UIControlStateNormal];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth/3, ScreenWidth/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
