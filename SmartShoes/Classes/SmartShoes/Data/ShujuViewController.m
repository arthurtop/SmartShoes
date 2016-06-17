//
//  ShujuViewController.m
//  nRF Toolbox
//
//  Created by SINOWINNER on 16/5/9.
//  Copyright © 2016年 Nordic Semiconductor. All rights reserved.
//

#import "ShujuViewController.h"

@interface ShujuViewController ()<UUChartDataSource>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *dateTitleLabel1;
@property (strong, nonatomic) UILabel *dateTitleLabel2;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;

//@property (strong, nonatomic) UIScrollView *chartView1;
@property (strong, nonatomic) UIScrollView *chartView2;

@property (strong, nonatomic) UUChart *chart1;
@property (strong, nonatomic) UUChart *chart2;

@property (nonatomic ,copy) NSMutableArray *dateArray;
@property (nonatomic ,copy) NSArray *countArray;
@property (nonatomic ,strong) NSDateFormatter *formatter;
@end

@implementation ShujuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"数据", nil);
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon_01"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_02"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button1 setTitle:NSLocalizedString(@"日志", nil) forState:UIControlStateNormal];
    [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"button_02_press"] forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"button_01_press"] forState:UIControlStateSelected];
    _button1.tag = 333;
    [self.view addSubview:_button1];
    [_button1 addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button2 setTitle:NSLocalizedString(@"记录", nil) forState:UIControlStateNormal];
    [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"button_02_press"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"button_01_press"] forState:UIControlStateSelected];
    _button2.tag = 334;
    [self.view addSubview:_button2];
    [_button2 addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button3 setTitle:NSLocalizedString(@"曲线", nil) forState:UIControlStateNormal];
    [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"button_02_press"] forState:UIControlStateNormal];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"button_01_press"] forState:UIControlStateSelected];
    _button3.tag = 335;
    [self.view addSubview:_button3];
    [_button3 addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.leading.equalTo(@5);
        make.height.equalTo(@30);
        make.width.equalTo(_button3.mas_width);
    }];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(_button1.mas_right).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(_button1.mas_width);
    }];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(_button2.mas_right).offset(5);
        make.trailing.equalTo(@-5);
        make.height.equalTo(@30);
        make.width.equalTo(_button2.mas_width);
    }];
    
    UIView *upLine = [[UIView alloc]init];
    upLine.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.view addSubview:upLine];
    
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(_button1.mas_bottom).offset(4);
        make.width.equalTo(self.view.mas_width);
        make.leading.equalTo(@0);
    }];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(_button1.mas_bottom).offset(5);
        make.bottom.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view2];
    
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view3];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.height.equalTo(_scrollView.mas_height);
        make.width.equalTo(_scrollView.mas_width);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(view1.mas_right);
        make.height.equalTo(_scrollView.mas_height);
        make.width.equalTo(_scrollView.mas_width);
    }];
    
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(view2.mas_right);
        make.trailing.equalTo(@0);
        make.height.equalTo(_scrollView.mas_height);
        make.width.equalTo(_scrollView.mas_width);
    }];
    
    [self setupView1:view1];
    [self setupView2:view2];
    [self setupView3:view3];
    
    [_button1 sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    _dateTitleLabel1.text = [dateFormatter stringFromDate:[NSDate date]];
    _dateTitleLabel2.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedButton:(UIButton *)sender {
    _button1.selected = NO;
    _button2.selected = NO;
    _button3.selected = NO;
    sender.selected = YES;
    
    CGFloat x = 0;
    
    if (sender == _button1) {
        x = 0;
    }else if (sender == _button2) {
        x = ScreenWidth;
    }else if (sender == _button3) {
        x = ScreenWidth*2;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.contentOffset = CGPointMake(x, 0);
    }];
    
    
}

- (void)setupView1:(UIView*)view {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [view addSubview:leftButton];
    
    _dateTitleLabel1 = [[UILabel alloc]init];
    _dateTitleLabel1.textColor = [UIColor blackColor];
    [view addSubview:_dateTitleLabel1];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [view addSubview:rightButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@30);
        make.top.equalTo(@12.5);
        make.width.height.equalTo(@15);
    }];
    
    [_dateTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@30);
        make.top.equalTo(@5);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-30);
        make.top.equalTo(@12.5);
        make.width.height.equalTo(@15);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@40);
        make.height.equalTo(@1);
    }];
    
    UILabel *loadingLabel = [[UILabel alloc]init];
    loadingLabel.textColor = [UIColor colorWithWhite:0.500 alpha:1.000];
    loadingLabel.text = NSLocalizedString(@"正在加载中...", nil);
    [view addSubview:loadingLabel];
    
    [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY).offset(20);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@20);
    }];
}

- (void)setupView2:(UIView*)view {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [view addSubview:leftButton];
    
    _dateTitleLabel2 = [[UILabel alloc]init];
    _dateTitleLabel2.textColor = [UIColor blackColor];
    [view addSubview:_dateTitleLabel2];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [view addSubview:rightButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@30);
        make.top.equalTo(@12.5);
        make.width.height.equalTo(@15);
    }];
    
    [_dateTitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@30);
        make.top.equalTo(@5);
    }];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-30);
        make.top.equalTo(@12.5);
        make.width.height.equalTo(@15);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@40);
        make.height.equalTo(@1);
    }];

    _chart1 = [[UUChart alloc]initWithFrame:CGRectMake(10, 60, ScreenWidth, 230) dataSource:self style:UUChartStyleBar];
    [_chart1 showInView:view];
}

- (void)setupView3:(UIView*)view {
    _segmentedControl = [[UISegmentedControl alloc]init];
    _segmentedControl.tintColor = [UIColor colorWithRed:1.000 green:0.163 blue:0.656 alpha:1.000];
    [view addSubview:_segmentedControl];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(@5);
    }];
    
    _chartView2 = [[UIScrollView alloc]init];
    _chartView2.showsHorizontalScrollIndicator = NO;
    _chartView2.showsVerticalScrollIndicator = NO;
    _chartView2.backgroundColor = [UIColor whiteColor];
    [view addSubview:_chartView2];
    
    NSInteger count = self.dateArray.count;
    self.chartView2.contentSize = CGSizeMake(count * 22+22, 220);
    
    [_chartView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(_segmentedControl.mas_bottom).offset(10);
        make.bottom.equalTo(@10);
    }];
    
    _chart2 = [[UUChart alloc]initWithFrame:CGRectMake(10, 10, count * 22, 230) dataSource:self style:UUChartStyleLine];
    [_chart2 showInView:_chartView2];
}

-(NSArray *)countArray{
    if (!_countArray) {
        _countArray = @[@"23",@"42",@"25",@"15",@"30",@"42",@"32",@"40",@"42",@"25",@"33"];
    }
    return _countArray;
}

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"MM-dd"];
    }
    return _formatter;
}

- (NSMutableArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
        NSDate *date = [NSDate new];
        for (NSInteger i = 29 ; i > -1 ; i --) {
            NSDate *thisDate =  [NSDate dateWithTimeInterval:- i * 24 * 3600 sinceDate:date];
            [_dateArray addObject:[self.formatter stringFromDate:thisDate]];
        }
    }
    return _dateArray;
}

#pragma mark - UUChartDataSource
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart{
    return self.dateArray;
}

- (NSArray *)chartConfigAxisYValue:(UUChart *)chart{
    return @[self.countArray];
}

//显示数值范围
- (CGRange)chartRange:(UUChart *)chart {
    NSInteger max = 0;
    NSInteger min = NSIntegerMax;
    for (NSString *count in self.countArray) {
        if (count.intValue > max) {
            max = count.intValue;
        }
        if (count.intValue < min) {
            min = count.intValue;
        }
    }
    if (!max) {
        max = 100;
    }
    return CGRangeMake(max, min);
    
}


//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index{
    return YES;
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
