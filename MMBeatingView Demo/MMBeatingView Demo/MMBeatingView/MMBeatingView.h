//
//  MMBeatingView.h
//  MMBeatingView Demo
//
//  Created by uSpeak on 09/08/13.
//  Copyright (c) 2013 mms. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMBeatingView;

@protocol MMBeatingViewDelegateDataSource <NSObject>
//letters to populate the puzzle
- (NSArray*)stringsSourceForBeatingView:(MMBeatingView*)wordSearchPuzzle;
@end

//protocol method
@protocol MMBeatingViewDelegate <NSObject>
-(void)didTouchOptionWithString:(NSString*)string forBeatingView:(MMBeatingView*)beatingView;
@end

//Subclass of UIView that beats with the pace you set
@interface MMBeatingView : UIView

//properties
@property (nonatomic, assign) CGFloat duration;     //duration
@property (nonatomic, assign) CGFloat minRadious;   //min radious
@property (nonatomic, strong) UIFont *font;         //font for strings
@property (nonatomic, strong) UIColor *fontColor;   //font color
@property (nonatomic, strong) UIColor *fillColor;   //fill color of circle

//delegate and datasource
@property (nonatomic, assign) IBOutlet id<MMBeatingViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<MMBeatingViewDelegateDataSource> dataSource;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
- (void)reloadData;

@end
