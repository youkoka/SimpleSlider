//
//  ViewController.m
//  SimpleSilder
//
//  Created by YenHenChia on 2016/7/19.
//  Copyright © 2016年 YenHenChia. All rights reserved.
//

#import "ViewController.h"
#import "SliderControl.h"

@interface ViewController ()<SliderControlDelegate>

@property (nonatomic, assign) IBOutlet UILabel *lbValue;

@property (nonatomic, assign) IBOutlet SliderControl *sliderControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sliderControl.sliderMinValue = 50;
    self.sliderControl.sliderMaxValue = 100;
    
    self.sliderControl.sliderActivityColor = [UIColor redColor];
    self.sliderControl.sliderBGColor = [UIColor grayColor];
    self.sliderControl.diameterColor = [UIColor greenColor];
    
    self.sliderControl.sliderControlDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) currentSliderValue:(CGFloat) currentValue minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue {
    
    self.lbValue.text = [NSString stringWithFormat:@"%.f", currentValue];
    
    NSLog(@"current value = %f, min value = %f, max value = %f", currentValue, minValue, maxValue);
}
@end
