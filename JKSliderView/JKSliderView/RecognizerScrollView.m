//
//  RecognizerScrollView.m
//  JKSliderView
//
//  Created by Jakin on 2017/9/10.
//  Copyright © 2017年 Jakin. All rights reserved.
//

#import "RecognizerScrollView.h"

@implementation RecognizerScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        if ([pan translationInView:self].x > 0 && self.contentOffset.x == 0) {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
