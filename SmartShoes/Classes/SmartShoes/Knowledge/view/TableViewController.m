//
//  TableViewController.m
//  SmartShoes
//
//  Created by hanxin on 16/5/26.
//  Copyright © 2016年 liuhongyang. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "zhishiMMViewController.h"
#import "KnowlegeModel.h"


@interface TableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"KnowlegeInfo" ofType:@"plist"];
    NSMutableDictionary *strategyDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *array = [strategyDic objectForKey:@"knowledge"];
    //NSLog(@"%@",array);
    
    for (int i = 0; i < array.count; i++) {
        KnowlegeModel *infoModel = [[KnowlegeModel alloc] initWithDict:array[i]];
        [_dataArray addObject:infoModel];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;//返回标题数组中元素的个数来确定分区的个数
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArray.count;
    
}


//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 135;
}
//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
//    ／／初始化cell并指定其类型，也可自定义cell
    
    TableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell=[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    //cell.frame=CGRectMake(0, 0, self.view.frame.size.width,135) ;
    
    if (_dataArray != nil) {
        KnowlegeModel *model = _dataArray[indexPath.row];
        cell.textlable.text = model.tilteStr;
        [cell.imageMM setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model.imageStr]]];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    zhishiMMViewController* avc=[[zhishiMMViewController alloc] init];
    [self.navigationController pushViewController:avc animated:YES];
    
    
}



@end
