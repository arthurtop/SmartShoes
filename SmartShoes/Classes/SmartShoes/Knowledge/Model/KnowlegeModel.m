//
//  KnowlegeModel.m
//  SmartShoes
//
//  Created by songlei on 16/5/31.
//  Copyright © 2016年 liuhongyang. All rights reserved.
//

#import "KnowlegeModel.h"

@implementation KnowlegeModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.tilteStr = dict[@"title"];
        self.imageStr = dict[@"image"];
        
    }
    return self;
}



@end



