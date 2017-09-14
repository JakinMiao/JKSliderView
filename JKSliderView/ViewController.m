//
//  ViewController.m
//  JKSliderView
//
//  Created by Jakin on 2017/9/10.
//  Copyright © 2017年 Jakin. All rights reserved.
//

#import "ViewController.h"
#import "JKOneController.h"
#import "JKTwoController.h"
#import "JKThreeController.h"
#import "JKSliderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JKOneController *one = [[JKOneController alloc] init];
    [self addChildViewController:one];
    JKTwoController *two = [[JKTwoController alloc] init];
    [self addChildViewController:two];
    JKThreeController *three = [[JKThreeController alloc] init];
    [self addChildViewController:three];
    
    NSArray *contentViews = @[one.view, two.view, three.view];
    NSArray *titles = @[@"Jakin", @"Niko", @"Philip"];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 64);
    JKSliderView *sliderView = [[JKSliderView alloc] initWithFrame:rect titles:titles contentViews:contentViews];
    [self.view addSubview:sliderView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
