//
//  SliderControl.h
//  SimpleSilder
//
//  Created by YenHenChia on 2016/7/19.
//  Copyright © 2016年 YenHenChia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderControlDelegate <NSObject>

-(void) currentSliderValue:(CGFloat) value minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue;

@end

@interface SliderControl : UIControl

@property (nonatomic, assign) id<SliderControlDelegate> sliderControlDelegate;

@property (nonatomic, assign) CGFloat sliderMinValue;

@property (nonatomic, assign) CGFloat sliderMaxValue;

@end
