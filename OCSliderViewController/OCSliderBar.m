                                                                                                                                                                                                                                                                                                                              //
//  TopSliderBar.m
//  HotelFan2
//
//  Created by bingdian on 15/11/12.
//  Copyright © 2015年 bingdian. All rights reserved.
//

#import "OCSliderBar.h"

#define ocSliderButtonTag 200

//顶部栏高度
#define ocSliderBarHeight 40
//顶部按钮宽度
#define ocSliderBtnWidth 64

@interface OCSliderBar () {
    UIButton *selSliderButton;//选中按钮
    UIView *biView;//底部指示条
    NSInteger buttonCount;
    
    CGFloat barWidth;
}

@end

@implementation OCSliderBar
@synthesize delegateObj,selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleAry {
    self = [super initWithFrame:frame];
    if (self) {
        buttonCount = titleAry.count;
        
        CGFloat btnWidth = titleAry.count<=frame.size.width/ocSliderBtnWidth ? self.bounds.size.width/titleAry.count : ocSliderBtnWidth;
        barWidth = btnWidth;
        for (int index = 0;index<titleAry.count; index++) {
            [self setupSliderBtnWithIndex:index title:titleAry[index] buttonWidth:btnWidth];
        }

        UIView *biv = [[UIView alloc] initWithFrame:CGRectMake((btnWidth-50)/2, ocSliderBarHeight-4, 50, 2)];
        biView = biv;
        biv.backgroundColor = [UIColor colorWithRed:0.1 green:0.58 blue:0.95 alpha:1.0];
        [self addSubview:biv];
        [biv release];
  
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, ocSliderBarHeight-1, frame.size.width, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:line];
        [line release];
        
        self.contentSize = CGSizeMake(btnWidth*titleAry.count, ocSliderBarHeight);
    }
    return self;
}

- (void)setupSliderBtnWithIndex:(NSInteger)index title:(NSString *)title buttonWidth:(CGFloat)btnWidth{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.tag = index+ocSliderButtonTag;
    btn.frame = CGRectMake(index * btnWidth, 0, btnWidth, ocSliderBarHeight-4);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickSliderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (index == selectedIndex) {
        btn.selected = YES;
        selSliderButton = btn;
    }
}

#pragma mark - 事件方法

- (void)clickSliderBtn:(UIButton *)sliderBtn {
    if (selSliderButton == sliderBtn) {
        return;
    }
    
    if (delegateObj) {
        [delegateObj OCSliderBarClickButtonFromIndex:selSliderButton.tag-ocSliderButtonTag toIndex:sliderBtn.tag-ocSliderButtonTag];
    }
}

- (void)changeOCSliderBarStatusWithSelectedIndex:(NSInteger)aSelectedIndex {
    
    UIButton *sliderBtn = [self viewWithTag:aSelectedIndex+ocSliderButtonTag];
    
    selectedIndex = sliderBtn.tag-ocSliderButtonTag;
    
    if (sliderBtn.tag < selSliderButton.tag) {
        if (sliderBtn.tag-ocSliderButtonTag <= 2) {
            if (self.contentOffset.x != 0) {
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentOffset = CGPointMake(0, 0);
                }];
            }
        }
        else {
            if (self.contentOffset.x > (sliderBtn.tag-ocSliderButtonTag-2)*ocSliderBtnWidth) {
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentOffset = CGPointMake((sliderBtn.tag-ocSliderButtonTag-2)*ocSliderBtnWidth, 0);
                }];
            }
        }
    }
    else {
        if (sliderBtn.tag-ocSliderButtonTag >= buttonCount - 2) {
            if (self.contentOffset.x != (self.contentSize.width - self.bounds.size.width)) {
                [UIView animateWithDuration:0.15 animations:^{
                    
                    self.contentOffset = CGPointMake(self.contentSize.width - self.bounds.size.width, 0);
                }];
            }
        }
        else {
            if (self.contentOffset.x < ((sliderBtn.tag-ocSliderButtonTag+3)*ocSliderBtnWidth - self.bounds.size.width)) {
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentOffset = CGPointMake((sliderBtn.tag-ocSliderButtonTag+3)*ocSliderBtnWidth - self.bounds.size.width, 0);
                }];
            }
        }
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        biView.transform = CGAffineTransformTranslate(biView.transform, (sliderBtn.tag - selSliderButton.tag)*barWidth, 0);
    }];
    
    selSliderButton.selected = NO;
    selSliderButton = sliderBtn;
    selSliderButton.selected = YES;
}

- (void)dealloc {
    [super dealloc];
    NSLog(@"OCSliderBar被销毁了");
}

@end
