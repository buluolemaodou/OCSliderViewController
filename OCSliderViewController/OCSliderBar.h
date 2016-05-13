//
//  TopSliderBar.h
//  HotelFan2
//
//  Created by bingdian on 15/11/12.
//  Copyright © 2015年 bingdian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OCSliderBarDelegate <NSObject>

-(void)OCSliderBarClickButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

@interface OCSliderBar : UIScrollView {
    id<OCSliderBarDelegate> delegateObj;
    
    NSInteger selectedIndex;
}

@property (nonatomic,assign) id<OCSliderBarDelegate> delegateObj;

@property (nonatomic,assign) NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;

- (void)changeOCSliderBarStatusWithSelectedIndex:(NSInteger)aSelectedIndex;

@end
