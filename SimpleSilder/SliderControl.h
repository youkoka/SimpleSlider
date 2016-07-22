//
//  SliderControl.h
//  SimpleSilder
//
//  Created by YenHenChia on 2016/7/19.
//  Copyright © 2016年 YenHenChia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderControlDelegate <NSObject>

@optional

-(void) beginSliderValue:(CGFloat) currentValue minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue;

-(void) continueSliderValue:(CGFloat) currentValue minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue;

-(void) endSliderValue:(CGFloat) currentValue minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue;

@end

@interface SliderControl : UIControl

@property (nonatomic, assign) id<SliderControlDelegate> sliderControlDelegate;

@property (nonatomic, assign) CGFloat sliderMinValue;

@property (nonatomic, assign) CGFloat sliderMaxValue;

@property (nonatomic, strong) UIColor *sliderBGColor;

@property (nonatomic, strong) UIColor *sliderPlayableColor;

@property (nonatomic, strong) UIColor *sliderActivityColor;

@property (nonatomic, strong) UIColor *diameterColor;

-(void) setPlaybackTime:(CGFloat) time;

-(void) setPlayableDuration:(CGFloat) time;


@end
