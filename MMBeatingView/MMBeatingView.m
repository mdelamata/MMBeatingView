//
//  MMBeatingView.m
//  MMBeatingView Demo
//
//  Created by uSpeak on 09/08/13.
//  Copyright (c) 2013 mms. All rights reserved.
//

#import "MMBeatingView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HSVExtras.h"

//Subclass of CATextLayer to get vertical alignment
@interface MMTextLayer : CATextLayer
@property (nonatomic,assign) CGPoint center;        //aux center calculation
@end

@implementation MMTextLayer

-(CGPoint)center{
    return CGPointMake(self.frame.origin.x + self.frame.size.width/2,
                       self.frame.origin.y + self.frame.size.height/2);
}
- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat height, fontSize;
    
    height = self.bounds.size.height;
    fontSize = self.fontSize;

    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0, height/2 - fontSize/2 -2.0);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}
@end


///////////// MMBeatingView///////////////
@interface MMBeatingView (){
    CGFloat circleRadius;
    CAShapeLayer *circle;
    MMTextLayer *textLayer;
}

// Default configuration
- (void)setDefaultConfig;
- (void)repeatAnimation;
- (void)handleTouchView:(UIGestureRecognizer*)gesture;

@property (assign) BOOL animating;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *stringsToShow;
@property (nonatomic,assign) NSInteger step;

@end

@implementation MMBeatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaultConfig];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setDefaultConfig];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    self.stringsToShow = [self.dataSource stringsSourceForBeatingView:self];
    [self drawString];
}


#pragma mark - Privated Methods

//this is the configuration by default
-(void)setDefaultConfig{
    self.backgroundColor = [UIColor clearColor];
    self.minRadious = 50.0f;
    self.duration = 2.0f;
    self.animating = NO;
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.fontColor = [UIColor whiteColor];
    self.fillColor = [UIColor redColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchView:)];
    [self addGestureRecognizer:tapGesture];
    
    //gets the letters to draw
    self.step = 0;
}

//this method is call every "duration" parameter time to repaint everything and trigger the subviews layout routines
- (void)repeatAnimation{
    [self setNeedsLayout];
}

//handles the touching of the circle
-(void)handleTouchView:(UIGestureRecognizer*)gesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchOptionWithString:forBeatingView:)]) {
        [self.delegate didTouchOptionWithString:textLayer.string forBeatingView:self];
    }
}

#pragma mark - Drawing Methods

+ (Class)layerClass {
    return [CAShapeLayer class];
}

//each loop layoutSubviews will draw again everything with new parameters
- (void)layoutSubviews {
    [self setLayerProperties];
    [self drawString];
    [self attachAnimations];
}

//here it gets the circle shape
- (void)setLayerProperties {
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    layer.fillColor = self.fillColor.CGColor;
}

- (void)attachAnimations {

    //[self setUserInteractionEnabled:NO];
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
           // [self setUserInteractionEnabled:YES];
            [self attachPathBounceAnimation];
        }];
        [self attachPathAnimation];
        [self attachColorAnimation];
        //[self attachStringAnimation];
    } [CATransaction commit];
}

- (void)attachPathAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.minRadious*2, self.minRadious*2)].CGPath;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)attachPathBounceAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.autoreverses = YES;
    animation.repeatCount = 1;
    animation.duration = 0.2;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.minRadious*2*0.1, self.minRadious*2*0.1)].CGPath;
    animation.fromValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)attachColorAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)[UIColor colorWithHue:self.fillColor.hue saturation:self.fillColor.saturation brightness:self.fillColor.brightness-0.4 alpha:1].CGColor;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)attachStringAnimation {
    
    CABasicAnimation *animX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animX.fromValue = [NSNumber numberWithInt:0.1];
    animX.toValue = [NSNumber numberWithInt:0.1];
    animX.removedOnCompletion = NO;

    CABasicAnimation *animY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animY.fromValue = [NSNumber numberWithInt:0.1];
    animY.toValue = [NSNumber numberWithInt:0.1];
    animY.removedOnCompletion = NO;

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:animX,animY,nil];
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = self.duration;
   
    [textLayer addAnimation:animationGroup forKey:@"animations"];
    
}


- (CABasicAnimation *)animationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.duration = 0.5;
    animation.removedOnCompletion = YES;
    return animation;
}

- (void)drawString{
    
    if (!textLayer) {
        textLayer = [[MMTextLayer alloc] init];
        [textLayer setFrame:self.bounds];
        [textLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [textLayer setForegroundColor:self.fontColor.CGColor];
        [textLayer setFont:(__bridge CFTypeRef)([NSString stringWithFormat:@"%@",self.font.fontName])];
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setFontSize:self.font.pointSize];
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
    }else{
        [textLayer removeFromSuperlayer];
    }
    
    if ([self.stringsToShow count]>self.step) {
        [textLayer setString:[self.stringsToShow objectAtIndex:self.step]];
        [self.layer addSublayer:textLayer];
        
        self.step ++;
        if (self.step >= [self.stringsToShow count]) {
            self.step = 0;
        }
    }
    
}

#pragma mark - Public Methods

//starts the animation
- (void)startAnimating{
    
    if (!self.animating) {
        
        self.animating = YES;        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration
                                                      target:self
                                                    selector:@selector(repeatAnimation)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//stops the animation and invalidates the timer
- (void)stopAnimating{
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    self.animating = NO;
}

//method that indicates if the animations is currently on going
-(BOOL)isAnimating{
    return self.animating;
}

//reloads the source Array for datasource
-(void)reloadData{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stringsSourceForBeatingView:)]) {
        self.stringsToShow = [self.dataSource stringsSourceForBeatingView:self];
    }
}
@end
