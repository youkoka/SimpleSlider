//
//  SliderControl.m
//  SimpleSilder
//
//  Created by YenHenChia on 2016/7/19.
//  Copyright © 2016年 YenHenChia. All rights reserved.
//

#import "SliderControl.h"

#define SPHERICAL_DIAMETER  16

#define SLIDER_BG_HEIGHT    2

@interface SliderControl()

@property (nonatomic, strong) CALayer *sliderBGLayer;

@property (nonatomic, strong) CALayer *sliderActivityLayer;

@property (nonatomic, strong) CALayer *sphericalLayer;

@property (nonatomic, assign) CGFloat percentage;

-(void) initializeControl;

-(CGFloat) getPrecentValueByWidth:(CGFloat) value;

-(void) updateActivityLayerFrame;

-(void) updateSphericalPosition;

@end

@implementation SliderControl

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if(self)
    {
        [self initializeControl];
    }
    return self;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self initializeControl];
    }
    
    return self;
}

-(void) initializeControl {
    
    self.sliderBGLayer = [CALayer layer];
    self.sliderBGLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:self.sliderBGLayer];
    
    self.sliderActivityLayer = [CALayer layer];
    self.sliderActivityLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:self.sliderActivityLayer];
    
    self.sphericalLayer = [CALayer layer];
    self.sphericalLayer.frame = CGRectMake(0, self.sliderBGLayer.frame.origin.y, SPHERICAL_DIAMETER, SPHERICAL_DIAMETER);
    self.sphericalLayer.cornerRadius = SPHERICAL_DIAMETER / 2;
    self.sphericalLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:self.sphericalLayer];
    
    self.percentage = 0;
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    self.sliderBGLayer.frame = CGRectMake(0, self.layer.frame.size.height / 2, self.layer.frame.size.width, SLIDER_BG_HEIGHT);
    
    [self updateActivityLayerFrame];
    [self updateSphericalPosition];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint pressedPoint = [touch locationInView:self];

    if (pressedPoint.x < 0) {
        
        pressedPoint.x = 0;
    }
    else if(pressedPoint.x > CGRectGetMaxX(self.sliderBGLayer.frame)) {
        
        pressedPoint.x = CGRectGetMaxX(self.sliderBGLayer.frame);
    }

    self.percentage = [self getPrecentValueByWidth:pressedPoint.x];
    
    [self updateActivityLayerFrame];
    [self updateSphericalPosition];
    
    [self animateHandle:self.sphericalLayer withSelection:YES];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
 
    CGPoint pressedPoint = [touch locationInView:self];
    
    if (pressedPoint.x < 0) {
        
        pressedPoint.x = 0;
    }
    else if(pressedPoint.x > CGRectGetMaxX(self.sliderBGLayer.frame)) {
    
        pressedPoint.x = CGRectGetMaxX(self.sliderBGLayer.frame);
    }
    
    self.percentage = [self getPrecentValueByWidth:pressedPoint.x];
    
    [self updateActivityLayerFrame];
    [self updateSphericalPosition];
    
    [self animateHandle:self.sphericalLayer withSelection:YES];
    
    if (self.sliderControlDelegate != nil) {
        
        if ([self.sliderControlDelegate respondsToSelector:@selector(currentSliderValue:minValue:andMaxValue:)]) {
            
            CGFloat diffValue = self.sliderMaxValue - self.sliderMinValue;
            CGFloat currentValue = diffValue * self.percentage;
            
            [self.sliderControlDelegate currentSliderValue:currentValue minValue:self.sliderMinValue andMaxValue:self.sliderMaxValue];
        }
    }

    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {

    [self animateHandle:self.sliderActivityLayer withSelection:NO];
    [self animateHandle:self.sphericalLayer withSelection:NO];
}

#pragma mark - Animation
- (void)animateHandle:(CALayer*)handle withSelection:(BOOL)selected {
    
    if (selected){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.3];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DMakeScale(1.5, 1.5, 1);
        
        [CATransaction setCompletionBlock:^{
        }];
        [CATransaction commit];
        
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.3];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DIdentity;
        
        [CATransaction commit];
    }
}

#pragma mark - Private methods

-(CGFloat) getPrecentValueByWidth:(CGFloat) value {
    
    CGFloat minWidth = 0;
    CGFloat maxWidth = CGRectGetMaxX(self.sliderBGLayer.frame);
    
    CGFloat diffWidth = maxWidth - minWidth;
    
    CGFloat valueSubtracted = value - 0;
    
    return valueSubtracted / diffWidth;
}

-(void) updateActivityLayerFrame {
    
    CGFloat offsetX = self.percentage * CGRectGetMaxX(self.sliderBGLayer.frame);
    
    self.sliderActivityLayer.frame = CGRectMake(0, self.layer.frame.size.height / 2, offsetX, SLIDER_BG_HEIGHT);
}

-(void) updateSphericalPosition {
    
    CGFloat offsetX = self.percentage * CGRectGetMaxX(self.sliderBGLayer.frame);
    
    self.sphericalLayer.position = CGPointMake(offsetX, self.sliderBGLayer.frame.origin.y);
}

@end
