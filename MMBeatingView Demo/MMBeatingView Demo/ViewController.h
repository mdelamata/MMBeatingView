//
//  ViewController.h
//  MMBeatingView Demo
//
//  Created by uSpeak on 09/08/13.
//  Copyright (c) 2013 mms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBeatingView.h"

@interface ViewController : UIViewController <MMBeatingViewDelegate, MMBeatingViewDelegateDataSource>
@property (nonatomic,strong) IBOutlet MMBeatingView *beatingView;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@end
