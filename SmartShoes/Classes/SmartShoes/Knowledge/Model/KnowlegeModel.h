//
//  KnowlegeModel.h
//  SmartShoes
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 liuhongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowlegeModel : NSObject

@property (nonatomic, strong) NSString *tilteStr;

@property (nonatomic, strong) NSString *imageStr;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end
