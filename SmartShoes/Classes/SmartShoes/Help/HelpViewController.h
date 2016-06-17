//
//  HelpViewController.h
//  nRF Toolbox
//
//  Created by Nordic Semiconductor on 06/02/14.
//  Copyright (c) 2014 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property (strong, nonatomic) NSString *helpText;

@property (weak, nonatomic) IBOutlet UITextView *helpTextView;
@end
