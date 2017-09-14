//
//  JKSliderView.h
//  JKSliderView
//
//  Created by Jakin on 2017/9/10.
//  Copyright © 2017年 Jakin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecognizerScrollView.h"




@interface JKSliderView : UIView

/** 视图切换的回调方法 */
typedef void(^SliderSelectIndex)(NSInteger index);

/** 视图的标题  */
@property (nonatomic, copy  ) NSArray *titles;

/** 显示的视图 */
@property (nonatomic, strong) NSArray *contentViews;

/** 选中的index */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL isAllowHandleScroll;

@property (nonatomic, assign) BOOL isBounces;

@property (nonatomic, assign) BOOL isShowButtonAnimation;

@property (nonatomic, assign) NSInteger subViewCount;

@property (nonatomic, assign) NSInteger baseTag;

@property (nonatomic, copy  ) SliderSelectIndex sliderSelectIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles contentViews:(NSArray *)contentViews;
@end
