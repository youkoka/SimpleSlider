//
//  SliderControl.m
//  SimpleSilder
//
//  Created by YenHenChia on 2016/7/19.
//  Copyright © 2016年 YenHenChia. All rights reserved.
//

#import "SliderControl.h"

#define SPHERICAL_DIAMETER  16

#define SLIDER_BG_HEIGHT    3

@interface SliderControl()

@property (nonatomic, strong) CALayer *sliderBGLayer;

@property (nonatomic, strong) CALayer *sliderActivityLayer;

@property (nonatomic, strong) CALayer *sliderPlayableLayer;

@property (nonatomic, strong) CALayer *sphericalLayer;

@property (nonatomic, assign) CGFloat playableDurationPosX;

@property (nonatomic, assign) CGFloat sphericalPosX;

@property (nonatomic, assign) CGFloat playingTime;

@property (nonatomic, assign) CGFloat playableTime;

-(void) initializeControl;

-(CGFloat) getPrecentByValue:(CGFloat) value;

-(float)getXPositionAlongLineForValue:(float) value;

-(void) updateBackgroundLayerFrame;

-(void) updatePlayableLayerFrame:(CGFloat) posX;

-(void) updateActivityLayerFrame:(CGFloat) posX;

-(void) updateSphericalPosition:(CGFloat) posX;

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
    [self.layer addSublayer:self.sliderBGLayer];
    
    self.sliderPlayableLayer = [CALayer layer];
    [self.layer addSublayer:self.sliderPlayableLayer];
    
    self.sliderActivityLayer = [CALayer layer];
    [self.layer addSublayer:self.sliderActivityLayer];
    
    self.sphericalLayer = [CALayer layer];
    self.sphericalLayer.frame = CGRectMake(0, self.sliderBGLayer.frame.origin.y / 2, SPHERICAL_DIAMETER, SPHERICAL_DIAMETER);
    self.sphericalLayer.cornerRadius = SPHERICAL_DIAMETER / 2;
    [self.layer addSublayer:self.sphericalLayer];
    
    self.sphericalPosX = 0;
    self.playingTime = 0;
    self.playableDurationPosX = 0;
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    self.sliderBGLayer.backgroundColor = self.sliderBGColor.CGColor;
    self.sliderPlayableLayer.backgroundColor = self.sliderPlayableColor.CGColor;
    self.sliderActivityLayer.backgroundColor = self.sliderActivityColor.CGColor;
    self.sphericalLayer.backgroundColor = self.diameterColor.CGColor;
    
    self.sphericalPosX = [self getXPositionAlongLineForValue:_playingTime];
    self.playableDurationPosX = [self getXPositionAlongLineForValue:_playableTime];
    
    [self updateBackgroundLayerFrame];
    [self updatePlayableLayerFrame:_playableDurationPosX];
    [self updateActivityLayerFrame:_sphericalPosX];
    [self updateSphericalPosition:_sphericalPosX];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pressedPoint = [touch locationInView:self];
    
    if (pressedPoint.x < 0) {
        
        pressedPoint.x = 0;
    }
    else if(pressedPoint.x > CGRectGetMaxX(self.sliderBGLayer.frame)) {
        
        pressedPoint.x = CGRectGetMaxX(self.sliderBGLayer.frame);
    }
    
    float percentage = pressedPoint.x / CGRectGetMaxX(self.sliderBGLayer.frame);
    
    self.playingTime = percentage * (self.sliderMaxValue - self.sliderMinValue) + self.sliderMinValue;
    
    [self setPlaybackTime:_playingTime];
    
    [self animateHandle:self.sphericalLayer withSelection:YES];
    
    if (self.sliderControlDelegate != nil) {
        
        if ([self.sliderControlDelegate respondsToSelector:@selector(beginSliderValue:minValue:andMaxValue:)]) {
            
            [self.sliderControlDelegate beginSliderValue:_playingTime minValue:self.sliderMinValue andMaxValue:self.sliderMaxValue];
        }
    }
    
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
    
    float percentage = pressedPoint.x / CGRectGetMaxX(self.sliderBGLayer.frame);
    
    self.playingTime = percentage * (self.sliderMaxValue - self.sliderMinValue) + self.sliderMinValue;
    
    [self setPlaybackTime:_playingTime];
    
    [self animateHandle:self.sphericalLayer withSelection:YES];
    
    if (self.sliderControlDelegate != nil) {
        
        if ([self.sliderControlDelegate respondsToSelector:@selector(continueSliderValue:minValue:andMaxValue:)]) {
            
            [self.sliderControlDelegate continueSliderValue:_playingTime minValue:self.sliderMinValue andMaxValue:self.sliderMaxValue];
        }
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    [self animateHandle:self.sliderActivityLayer withSelection:NO];
    [self animateHandle:self.sphericalLayer withSelection:NO];
    
    if (self.sliderControlDelegate != nil) {
        
        if ([self.sliderControlDelegate respondsToSelector:@selector(endSliderValue:minValue:andMaxValue:)]) {
            
            [self.sliderControlDelegate endSliderValue:_playingTime minValue:self.sliderMinValue andMaxValue:self.sliderMaxValue];
        }
    }
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

-(CGFloat) getPrecentByValue:(CGFloat) value {
    
    if (self.sliderMinValue == self.sliderMaxValue) {
        
        return 0;
    }
    else if(value < self.sliderMinValue) {
        
        value = self.sliderMinValue;
    }
    
    CGFloat diffWidth = self.sliderMaxValue - self.sliderMinValue;
    
    CGFloat valueSubtracted = value - self.sliderMinValue;
    
    return valueSubtracted / diffWidth;
}

-(float)getXPositionAlongLineForValue:(float) value {
    
    float percentage = [self getPrecentByValue:value];
    
    float maxMinDif = CGRectGetMaxX(self.sliderBGLayer.frame);
    
    float offset = percentage * maxMinDif;
    
    return offset;
}

-(void) updateBackgroundLayerFrame {
    
    self.sliderBGLayer.frame = CGRectMake(0, self.layer.frame.size.height / 2, self.layer.frame.size.width, SLIDER_BG_HEIGHT);
}

-(void) updatePlayableLayerFrame:(CGFloat) posX {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sliderPlayableLayer.frame = CGRectMake(0, self.layer.frame.size.height / 2, posX, SLIDER_BG_HEIGHT);
    [CATransaction commit];
    
}
-(void) updateActivityLayerFrame:(CGFloat) posX {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sliderActivityLayer.frame = CGRectMake(0, self.layer.frame.size.height / 2, posX, SLIDER_BG_HEIGHT);
    [CATransaction commit];
}

-(void) updateSphericalPosition:(CGFloat) posX {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.sphericalLayer.position = CGPointMake(posX, self.sliderBGLayer.frame.origin.y);
    [CATransaction commit];
}

-(void) setPlaybackTime:(CGFloat) time {
    
    self.playingTime = time;
    self.sphericalPosX = [self getXPositionAlongLineForValue:time];
    
    [self updateActivityLayerFrame:_sphericalPosX];
    [self updateSphericalPosition:_sphericalPosX];
}

-(void) setPlayableDuration:(CGFloat) time {
    
    self.playableTime = time;
    self.playableDurationPosX = [self getXPositionAlongLineForValue:time];
    
    [self updatePlayableLayerFrame:_playableDurationPosX];
}

@end
