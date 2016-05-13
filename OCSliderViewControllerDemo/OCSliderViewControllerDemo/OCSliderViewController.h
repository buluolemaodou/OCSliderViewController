//
//  OCSliderViewController.h
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/4/12.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCSliderBar.h"
#import "OCSliderVCInteractiveDrive.h"



#pragma mark - OCSliderAnimator

@interface OCSliderAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end


//===============****************************************************=======================//

#pragma mark - OCSliderVCTransitioningContext

@class OCSliderVCTransitioningContext;
@protocol OCSliderVCTransitioningContextDelegate <NSObject>

@optional
-(void)OCSliderVCTransitioningContext:(OCSliderVCTransitioningContext *)context transitionCompleted:(BOOL)completed;

@end


//===============****************************************************=======================//

#pragma mark - OCSliderVCTransitioningContext

//OCSliderVCTransitioningContext对象，遵守UIViewControllerContextTransitioning协议。
//初始化此对象，用来存放animation transition时所需信息。
//初始化时，请使用initWithFromViewController:toViewController:containerView:方法，
//其中的参数都是进行animation transition时所必须用到的。

@interface OCSliderVCTransitioningContext : NSObject <UIViewControllerContextTransitioning> {
    BOOL animated;
    BOOL interactive;
    BOOL isRight;
    BOOL transitionWasCancelled;
    
    UIView *containerView;
    
    id<OCSliderVCTransitioningContextDelegate> delegate;
}

///动画发生的容器view
@property (nonatomic,assign) UIView *containerView;

///是否正在动画中
@property (nonatomic,assign,getter=isAnimated) BOOL animated;

///是否为可交互式动画
@property (nonatomic,assign,getter=isInteractive) BOOL interactive;

///动画是否被取消
@property (nonatomic,assign) BOOL transitionWasCancelled;

///设置滑动方向，如果向右滑动则返回YES，必须设置
@property (nonatomic,assign) BOOL isRight;

///delegate，动画完成之后通知代理
@property (nonatomic,assign) id<OCSliderVCTransitioningContextDelegate> delegate;

- (instancetype)initWithFromViewController:(UIViewController *)fromVc toViewController:(UIViewController *)toVc containerView:(UIView *)containerView;

@end


//===============****************************************************=======================//

#pragma mark - OCSliderViewController

@protocol OCSliderViewControllerDelegate;

//仅支持iOS7及以后
//自定义转场动画的过程可参考苹果官方文档UIViewController Programming Guide中自定义转场动画部分
//只需按文档中步骤实现即可，唯一的区别在于需要使用OCSliderVCInteractiveDrive替代UIKit的UIPercentDrivenInteractiveTransition类

@interface OCSliderViewController : UIViewController <OCSliderBarDelegate,OCSliderVCTransitioningContextDelegate> {
    NSArray *childViewControllers;
    
    UIViewController *selectedViewController;
    NSUInteger selectedIndex;
    
    OCSliderBar *sliderBar;
    UIColor *sliderBarBackgroundColor;
    
    id<OCSliderViewControllerDelegate> delegate;
}

@property (nonatomic,copy) NSArray *childViewControllers;

///当前正在显示的childViewController
@property (nonatomic,assign) UIViewController *selectedViewController;
- (void)setSelectedViewController:(UIViewController *)aSelectedViewController animated:(BOOL)animated;
@property (nonatomic,assign) NSUInteger selectedIndex;

///顶部滑动栏，默认高度为50
@property (nonatomic,assign,readonly) OCSliderBar *sliderBar;

@property (nonatomic,assign) id<OCSliderViewControllerDelegate> delegate;

@end


@protocol OCSliderViewControllerDelegate <NSObject>
@optional

/**
 *@description询问代理是否可以切换到某个childViewController，可以在此方法内部做一些事情，比如切换到某些控制器时需要验证是否登录...等。
 *返回YES或者NO,以便让OCSliderViewController知道是否可以切换
 *@params ocSliderViewController  当前子控制器所属的OCSliderViewController
 *@params viewController  即将跳转到的childViewController
 */
- (BOOL)OCSliderViewController:(OCSliderViewController *)ocSliderViewController shouldSlideToViewController:(UIViewController *)viewController;

/**
 *@description 通知代理已切换到某个子控制器
 *@params ocSliderViewController  当前子控制器所属的OCSliderViewController
 *@params viewController  已跳转到的childViewController
 */
- (void)OCSliderViewController:(OCSliderViewController *)ocSliderViewController didSliderToViewController:(UIViewController *)viewController;

/**
 *@description 代理实现此方法，返回实现UIViewControllerInteractiveTransitioning协议的对象
 *@params ocSliderViewController  参与交互式动画转场的ocSliderViewController
 *@params ocSliderViewController  非交互式animation Controller
 *@return 实现UIViewControllerInteractiveTransitioning协议的对象
 */
- (id <UIViewControllerInteractiveTransitioning>)ocSliderViewController:(OCSliderViewController *)ocSliderViewController
                            interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController;

/**
 *@description 代理实现此方法，返回实现UIViewControllerAnimatedTransitioning协议的对象
 *@params ocSliderViewController  参与动画转场的ocSliderViewController
 *@params fromVC  当前可见的控制器
 *@params toVc  转场结束后可见的控制器
 *@return 实现UIViewControllerAnimatedTransitioning协议的对象
 */
- (id <UIViewControllerAnimatedTransitioning>)ocSliderViewController:(OCSliderViewController *)ocSliderViewController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC;

@end


#pragma mark - UIViewController

@interface UIViewController (OCSliderViewController)

@property (nonatomic,copy) NSString *ocSliderBarTitle;

@property (nonatomic,retain) OCSliderViewController *ocSliderViewController;

@end


//===============****************************************************=======================//
#pragma mark - OCPrivateInteractiveController

@interface OCPrivateInteractiveController : OCSliderVCInteractiveDrive {
    OCSliderViewController *ocSliderViewController;
}

@property (nonatomic,assign) OCSliderViewController *ocSliderViewController;

@end





