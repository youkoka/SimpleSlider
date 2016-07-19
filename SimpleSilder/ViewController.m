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
    
    self.sliderControl.sliderMinValue = 0;
    self.sliderControl.sliderMaxValue = 100;
    
    self.sliderControl.sliderControlDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) currentSliderValue:(CGFloat) value minValue:(CGFloat)minValue andMaxValue:(CGFloat)maxValue {
    
    self.lbValue.text = [NSString stringWithFormat:@"%.f", value];
}
@end
