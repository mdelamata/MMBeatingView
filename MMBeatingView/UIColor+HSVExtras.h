//
//  UIColor+HSVExtras.h
//  MMS
//
//  Created by Manuel de la Mata on 12/07/13.
//  Copyright (c) 2013 MMS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct {
    int hueValue;
    int saturationValue;
    int brightnessValue;
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} HsvColor;

typedef struct {
    int redValue;
    int greenValue;
    int blueValue;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} RgbColor;

@interface UIColor (HSVExtras)

+ (HsvColor)hsvColorFromColor:(UIColor *)color;
+ (RgbColor)rgbColorFromColor:(UIColor *)color;

-(CGFloat)hue;
-(CGFloat)saturation;
-(CGFloat)brightness;
-(CGFloat)value;
-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(CGFloat)white;
-(CGFloat)alpha;

@end
