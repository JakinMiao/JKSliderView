//
//  JKSliderView.m
//  JKSliderView
//
//  Created by Jakin on 2017/9/10.
//  Copyright © 2017年 Jakin. All rights reserved.
//

#import "JKSliderView.h"
#import "UIColor+Hex.h"

CGFloat const JKTopViewHeight = 50;

CGFloat const JKTitleFontSize = 17;

CGFloat const JKLineSize = 1;

CGFloat const JKSliderHeight = 2;

CGFloat const JKSliderWidth = 0;

NSString const *JKTitleNormalColor = @"B0E0E6";

NSString const *JKTitleSelectedColor = @"FF00FF";

NSString const *JKLineColor = @"1E90FF";

NSString const *JKSliderColor = @"DC143C";

@interface JKSliderView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) RecognizerScrollView *recognizerScrollView;

@end

@implementation JKSliderView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles contentViews:(NSArray *)contentViews {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.contentViews = contentViews;
        self.baseTag = 1000;
        self.subViewCount = titles.count;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self makeTopView];
    [self addContentView];
}

- (void)makeTopView {
    CGFloat btnW = CGRectGetWidth(self.topView.bounds) / (CGFloat)_subViewCount;
    CGFloat btnH = CGRectGetHeight(self.topView.bounds);
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = (NSString *)obj;
        CGFloat btnX = idx * btnW;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, btnH)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:(NSString *)JKTitleNormalColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:(NSString *)JKTitleSelectedColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:JKTitleFontSize];
        button.tag = self.baseTag + idx;
        [button addTarget:self action:@selector(buttonSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == self.selectedIndex) {
            [button setEnabled:NO];
            self.selectedButton = button;
        }
        [self.topView addSubview:button];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), CGRectGetHeight(button.bounds) * 0.2, JKLineSize, CGRectGetHeight(button.bounds) * 0.6)];
        lineView.backgroundColor = [UIColor colorWithHexString:(NSString *)JKLineColor];
        [self.topView addSubview:lineView];
    }];
    [self.topView addSubview:self.sliderView];
}

- (void)addContentView {
    [self addSubview:self.recognizerScrollView];
    [_contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        CGFloat viewX = idx * CGRectGetWidth(self.recognizerScrollView.bounds);
        view.frame = CGRectMake(viewX, 0, CGRectGetWidth(self.recognizerScrollView.bounds), CGRectGetHeight(self.recognizerScrollView.bounds));
        [self.recognizerScrollView addSubview:view];
    }];
    self.recognizerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.recognizerScrollView.bounds) * _selectedIndex, 0);
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), JKTopViewHeight)];
        
        [self addSubview:_topView];
    }
    return _topView;
}

- (UIView *)sliderView {
    if (!_sliderView) {
        CGFloat sliderWidth = JKSliderWidth == 0 ? CGRectGetWidth(self.topView.frame) / (CGFloat)self.subViewCount : JKSliderWidth;
        CGFloat btnW = CGRectGetWidth(self.topView.bounds) / (CGFloat)_subViewCount;
        CGFloat sliderX = (btnW - sliderWidth) / 2.0;
        _sliderView = [[UIView alloc] initWithFrame:CGRectMake(sliderX , CGRectGetHeight(self.topView.frame) - 2, sliderWidth, JKSliderHeight)];
        _sliderView.backgroundColor = [UIColor blackColor];
    }
    return _sliderView;
}

- (RecognizerScrollView *)recognizerScrollView {
    if (!_recognizerScrollView) {
        _recognizerScrollView = [[RecognizerScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.topView.bounds))];
        _recognizerScrollView.delegate = self;
        _recognizerScrollView.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
        _recognizerScrollView.pagingEnabled = YES;
        _recognizerScrollView.scrollEnabled = YES;
        _recognizerScrollView.showsHorizontalScrollIndicator = YES;
        _recognizerScrollView.bounces = YES;
        _recognizerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * _subViewCount, 0);
        
    }
    return _recognizerScrollView;
}

- (void)buttonSelectedAction:(UIButton *)sender {
    if (_selectedButton == sender) {
        return;
    }
    
    [self changeSelectedButton:sender];
    
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger num = sender.tag - self.baseTag;
        self.recognizerScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.recognizerScrollView.bounds) * num, 0);
    }];
}

- (void)changeSelectedButton:(UIButton *)button {
    _selectedButton.enabled = YES;
    button.enabled = NO;
    _selectedButton = button;
    
    [self scaleAnimationTitleButton:button];
    
    if (self.sliderSelectIndex) {
        self.sliderSelectIndex(button.tag = self.baseTag);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat itemWidth = CGRectGetWidth(scrollView.bounds) / (CGFloat)_subViewCount;
    CGFloat XOffset = itemWidth / CGRectGetWidth(scrollView.bounds) * scrollView.contentOffset.x;
    _sliderView.transform = CGAffineTransformMakeTranslation(XOffset, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    UIButton *button = [_topView viewWithTag:index +  self.baseTag];
    [self changeSelectedButton:button];
}

- (void)scaleAnimationTitleButton:(UIButton *)button {
    
    [UIView animateWithDuration:0.25 animations:^{
        button.transform = CGAffineTransformMakeScale(0.75, 0.75);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            button.transform = CGAffineTransformMakeScale(1/0.9, 1/0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                button.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}
@end
