//
//  zhishiMMViewController.m
//  SmartShoes
//
//  Created by hanxin on 16/5/26.
//  Copyright © 2016年 liuhongyang. All rights reserved.
//

#import "zhishiMMViewController.h"

@interface zhishiMMViewController ()

@end

@implementation zhishiMMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height); // frame中的size指UIScrollView的可视范围
    // 设置UIScrollView的滚动范围（内容大小）
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.view.frame.size.height*2, 0);
//    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
        UILabel * lan=[[UILabel alloc] initWithFrame:CGRectMake(5, 20, self.view.frame.size.width-5, 400)];
        lan.text=@"不少细心的妈妈们会发现，出生不久的宝宝在睡觉的时候喜欢将小腿向内蜷缩起来。这是传说中的“罗圈腿”吗?其实，这是新生宝宝的下肢胫骨向外侧弯曲纯属正常的生理现象，随着宝宝的月龄增长，这种现象会慢慢消失。那么，怎样判断宝宝出现“罗圈腿?这些因素导致宝宝“罗圈腿”1.幼儿时患佝偻病所致。小儿佝偻病主要原因是缺乏维生素D。缺乏维生素D一方面是小肠吸收钙磷不足和肾脏排出钙磷增加，造成体内钙磷不足;另一方面是新骨生成障碍，不能钙化和已长成的骨骼脱钙。造成了婴儿罗圈腿。2.骨骼生长发育阶段，受到特殊的生活习惯影响。佝偻病一般是由维生素D缺乏所引起的。维生素D缺乏时，钙、磷在肠内吸收减少，钙、磷减少，一方面机体在甲状旁腺调节下使已长成的旧骨脱钙(旧骨硬度降低)，以弥补血中钙、磷不足;另一方面新骨由于缺钙而使骨质钙化不足而质地松软，肌肉关节松弛，直立行走时在重力作用下就会变形，导致了婴儿罗圈腿。";
        lan.numberOfLines = 0;
    lan.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//    CGSize expectSize = [lan sizeThatFits:maximumLabelSize];
//  //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//      lan.frame = CGRectMake(20, 70, expectSize.width, expectSize.height);
        [scrollView addSubview:lan];
        
        UIImageView * ima=[[UIImageView alloc] initWithFrame:CGRectMake(5, 500, self.view.frame.size.width, 150)];
        [ima setImage:[UIImage imageNamed:@"1.2.png"]];
        [scrollView addSubview:ima];
    
    UILabel * lan1=[[UILabel alloc] initWithFrame:CGRectMake(5, 500+150+44, self.view.frame.size.width-5, 400)];
    lan1.text=@"不少细心的妈妈们会发现，出生不久的宝宝在睡觉的时候喜欢将小腿向内蜷缩起来。这是传说中的“罗圈腿”吗?其实，这是新生宝宝的下肢胫骨向外侧弯曲纯属正常的生理现象，随着宝宝的月龄增长，这种现象会慢慢消失。那么，怎样判断宝宝出现“罗圈腿?这些因素导致宝宝“罗圈腿”1.幼儿时患佝偻病所致。小儿佝偻病主要原因是缺乏维生素D。缺乏维生素D一方面是小肠吸收钙磷不足和肾脏排出钙磷增加，造成体内钙磷不足;另一方面是新骨生成障碍，不能钙化和已长成的骨骼脱钙。造成了婴儿罗圈腿。2.骨骼生长发育阶段，受到特殊的生活习惯影响。佝偻病一般是由维生素D缺乏所引起的。维生素D缺乏时，钙、磷在肠内吸收减少，钙、磷减少，一方面机体在甲状旁腺调节下使已长成的旧骨脱钙(旧骨硬度降低)，以弥补血中钙、磷不足;另一方面新骨由于缺钙而使骨质钙化不足而质地松软，肌肉关节松弛，直立行走时在重力作用下就会变形，导致了婴儿罗圈腿。";
    lan1.numberOfLines = 0;
    lan1.lineBreakMode = NSLineBreakByTruncatingTail;
    //    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
    //    CGSize expectSize = [lan sizeThatFits:maximumLabelSize];
    //  //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    //      lan.frame = CGRectMake(20, 70, expectSize.width, expectSize.height);
    [scrollView addSubview:lan1];
    
    UIImageView * ima1=[[UIImageView alloc] initWithFrame:CGRectMake(5, (500+120+40+500), self.view.frame.size.width, 150)];
    [ima1 setImage:[UIImage imageNamed:@"1.2.png"]];
    [scrollView addSubview:ima1];
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
