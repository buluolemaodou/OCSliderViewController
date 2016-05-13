//
//  OCSliderViewController.m
//  OCSliderViewControllerDemo
//
//  Created by bingdian on 16/4/12.
//  Copyright © 2016年 bingdian. All rights reserved.
//

#define OCSliderBarHeight 60

#import "OCSliderViewController.h"
#import <objc/runtime.h>

#pragma mark - OCSliderViewController

@interface OCSliderViewController () {
    UIView *containerView;
    UIViewController *fromViewController;
    UIViewController *toViewController;
    
    OCPrivateInteractiveController *privateInteractiveController;
    id<UIViewControllerAnimatedTransitioning> ocSliderAnimator;
    OCSliderVCTransitioningContext *otc;
    NSUInteger tempIndex;
    
    OCSliderBar *ocSliderBar;
}

@property (nonatomic,assign) UIView *containerView;

@property (nonatomic,assign) UIViewController *fromViewController;
@property (nonatomic,assign) UIViewController *toViewController;

@property (nonatomic,assign) id<UIViewControllerAnimatedTransitioning> ocSliderAnimator;

@end

@implementation OCSliderViewController
@synthesize childViewControllers;
@synthesize selectedViewController,selectedIndex;
@synthesize containerView,sliderBar;
@synthesize delegate;
@synthesize fromViewController,toViewController,ocSliderAnimator;

#pragma mark - viewController's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self toSetupContent];
    [self toSetupPrivateInteractiveController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [privateInteractiveController release];
    [childViewControllers release];
    [super dealloc];
    NSLog(@"OCSliderViewController被销毁了");
}

#pragma mark - 事件方法
- (void)toSetupContent {
    UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0,20,self.view.bounds.size.width,self.view.bounds.size.height-20)];
    cv.backgroundColor = [UIColor clearColor];
    cv.clipsToBounds = YES;
    containerView = cv;
    [self.view addSubview:cv];
    [cv release];

    if (!childViewControllers || childViewControllers.count == 0) {
        return;
    }
    else {
        if (selectedViewController) {
            if ([childViewControllers containsObject:selectedViewController]) {
                selectedIndex = [childViewControllers indexOfObject:selectedViewController];
            }
            else {
                selectedViewController = childViewControllers[0];
                selectedIndex = 0;
            }
        }
        else {
            selectedViewController = childViewControllers[selectedIndex];
        }
        
        NSMutableArray *titleAry = [NSMutableArray array];
        
        for (int i=0; i<childViewControllers.count; i++) {
            UIViewController *childVc = childViewControllers[i];
            
            childVc.view.frame = [self frameForContentController];
            childVc.ocSliderViewController = self;
            
            if (childVc.ocSliderBarTitle) {
                [titleAry addObject:childVc.ocSliderBarTitle];
            }
            else {
                [titleAry addObject:@""];
            }
        }
        
        [self displayContentController:selectedViewController];
        
        //添加sliderBar
        CGRect sbRect = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), OCSliderBarHeight-20);
        OCSliderBar *sb = [[OCSliderBar alloc] initWithFrame:sbRect titleArray:[[titleAry copy] autorelease]];
        ocSliderBar = sb;
        sb.delegateObj = self;
        sb.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:sb aboveSubview:cv];
        [sb release];
    }
}

- (void)toSetupPrivateInteractiveController {
    OCPrivateInteractiveController *pic = [[OCPrivateInteractiveController alloc] init];
    privateInteractiveController = pic;
    pic.ocSliderViewController = self;
}

- (CGRect)frameForContentController {
    return self.view.bounds;
}

- (void)toSetupTransitionContextWithFromVC:(UIViewController *)fromVc toVc:(UIViewController *)toVC  Direction:(BOOL)isGoRight {
    OCSliderVCTransitioningContext *transitionContext = [[OCSliderVCTransitioningContext alloc] initWithFromViewController:fromVc toViewController:toVC containerView:self.containerView];
    transitionContext.delegate = self;
    transitionContext.isRight = isGoRight;
    transitionContext.animated = YES;
    otc = transitionContext;
}

- (void)sliderFromViewController:(UIViewController *)fromVc
             toNewViewController:(UIViewController *)toVC {
    tempIndex = selectedIndex;
    selectedIndex = [childViewControllers indexOfObject:toVC];
    selectedViewController = toVC;
    
    fromViewController = fromVc;
    toViewController = toVC;

    [fromVc willMoveToParentViewController:nil];
    [self addChildViewController:toVC];

    //判断有无animtor
    id <UIViewControllerAnimatedTransitioning> animator;
    if (delegate && [delegate respondsToSelector:@selector(ocSliderViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
        animator = [delegate ocSliderViewController:self animationControllerForTransitionFromViewController:fromViewController
                        toViewController:toViewController];
    }
    else {
        animator = [[OCSliderAnimator alloc] init];
    }
    
    if (otc.isInteractive) {
        //判断是否有可交互式动画驱动
        OCSliderVCInteractiveDrive *interactiveController;
        if (delegate && [delegate respondsToSelector:@selector(ocSliderViewController:interactionControllerForAnimationController:)]) {
            interactiveController = [delegate ocSliderViewController:self interactionControllerForAnimationController:animator];
            [interactiveController startInteractiveTransition:otc];
        }
        else {
            [privateInteractiveController startInteractiveTransition:otc];
        }
    }
    
    ocSliderBar.userInteractionEnabled = NO;
    
    ocSliderAnimator = animator;
    [animator animateTransition:otc];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = [self frameForContentController];
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void)setSelectedViewController:(UIViewController *)aSelectedViewController {
    [self setSelectedViewController:aSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)aSelectedViewController animated:(BOOL)animated{
    
    if (selectedViewController != aSelectedViewController) {

        if (animated) {
            BOOL isGoRight = selectedIndex < [childViewControllers indexOfObject:aSelectedViewController];
            
            [self toSetupTransitionContextWithFromVC:selectedViewController toVc:aSelectedViewController Direction:isGoRight];
            
            otc.interactive = YES;

            [self sliderFromViewController:selectedViewController toNewViewController:aSelectedViewController];
        }
        else {
            [self hideContentController:selectedViewController];
            [self displayContentController:aSelectedViewController];
            
            selectedIndex =  [self.childViewControllers indexOfObject:aSelectedViewController];
            selectedViewController = aSelectedViewController;
            
            [ocSliderBar changeOCSliderBarStatusWithSelectedIndex:selectedIndex];
            
            if (delegate && [delegate respondsToSelector:@selector(OCSliderViewController:didSliderToViewController:)]) {
                [delegate OCSliderViewController:self
                       didSliderToViewController:aSelectedViewController];
            }
        }
    }
}

#pragma mark - OCSliderVCTransitioningContextDelegate 
- (void)OCSliderVCTransitioningContext:(OCSliderVCTransitioningContext *)context transitionCompleted:(BOOL)completed {
    if (completed) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if (delegate && [delegate respondsToSelector:@selector(OCSliderViewController:didSliderToViewController:)]) {
            [delegate OCSliderViewController:self
                   didSliderToViewController:[context viewControllerForKey:UITransitionContextToViewControllerKey]];
        }
        
        if ([ocSliderAnimator respondsToSelector:@selector(animationEnded:)]) {
            [ocSliderAnimator animationEnded:completed];
        }
        
        [ocSliderBar changeOCSliderBarStatusWithSelectedIndex:selectedIndex];
    }
    else {
        [toViewController.view removeFromSuperview];
        [toViewController willMoveToParentViewController:nil];
        [toViewController removeFromParentViewController];
        
        //如果动画未完成,处理selectedIndex的改变
        selectedIndex = tempIndex;
        selectedViewController = childViewControllers[selectedIndex];
    }
    ocSliderBar.userInteractionEnabled = YES;
    [otc release];
    [ocSliderAnimator release];
}

#pragma mark - OCSliderBarDelegate 

- (void)OCSliderBarClickButtonFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    UIViewController *fromVc = childViewControllers[fromIndex];
    UIViewController *toVC = childViewControllers[toIndex];

    if (delegate && [delegate respondsToSelector:@selector(OCSliderViewController:shouldSlideToViewController:)]) {
        if (![delegate OCSliderViewController:self shouldSlideToViewController:toVC]) {
            return ;
        }
    }
    
    [self toSetupTransitionContextWithFromVC:fromVc
                                        toVc:toVC
                                   Direction:[childViewControllers indexOfObject:fromVc]<[childViewControllers indexOfObject:toVC]];
    otc.interactive = NO;
    [self sliderFromViewController:fromVc toNewViewController:toVC];
}

@end

//===============****************************************************=======================//

#pragma mark - UIViewController+OCSliderViewController implementation

@implementation UIViewController (OCSliderViewController)

- (void)setOcSliderBarTitle:(NSString *)ocSliderBarTitle {
    objc_setAssociatedObject(self, "ocSliderBarTitle", ocSliderBarTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ocSliderBarTitle {
    return objc_getAssociatedObject(self, "ocSliderBarTitle");
}

- (void)setOcSliderViewController:(UIViewController *)ocSliderViewController {
    objc_setAssociatedObject(self, "ocSliderViewController", ocSliderViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)ocSliderViewController {
    return objc_getAssociatedObject(self, "ocSliderViewController");
}

@end


//===============****************************************************=======================//

#pragma mark - OCSliderAnimator implementation

@implementation OCSliderAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isInteractive] ? 0.35 : 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    fromView.frame = [transitionContext initialFrameForViewController:fromVc];
    toView.frame = [transitionContext initialFrameForViewController:toVc];
    
    [[transitionContext containerView] addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.frame = [transitionContext finalFrameForViewController:fromVc];
        toView.frame = [transitionContext finalFrameForViewController:toVc];
    } completion:^(BOOL finished) {
        fromView.frame = [transitionContext initialFrameForViewController:fromVc];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {}

- (void)dealloc {
    [super dealloc];
    NSLog(@"OCSliderAnimator被销毁了");
}

@end

//===============****************************************************=======================//

#pragma mark - OCSliderVCTransitioningContext implementation

@interface OCSliderVCTransitioningContext () {
    UIModalPresentationStyle presentationStyle;
    NSDictionary *viewControllers;
    NSDictionary *views;
    
    CGRect fromViewAppearingFrame;
    CGRect fromViewDisappearingFrame;
    CGRect toViewAppearingFrame;
    CGRect toViewDisappearingFrame;
    
    UIView *shotFromView;
}

@property (nonatomic,assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic,copy) NSDictionary *viewControllers;
@property (nonatomic,copy) NSDictionary *views;

@property (nonatomic,assign) CGRect fromViewAppearingFrame;
@property (nonatomic,assign) CGRect fromViewDisappearingFrame;
@property (nonatomic,assign) CGRect toViewAppearingFrame;
@property (nonatomic,assign) CGRect toViewDisappearingFrame;

@end

@implementation OCSliderVCTransitioningContext
@synthesize animated,interactive,isRight,transitionWasCancelled;
@synthesize containerView,viewControllers,views,presentationStyle;
@synthesize fromViewAppearingFrame,fromViewDisappearingFrame,toViewAppearingFrame,toViewDisappearingFrame;
@synthesize delegate;

- (instancetype)initWithFromViewController:(UIViewController *)fromVc toViewController:(UIViewController *)toVc containerView:(UIView *)aContainerView{
    
    if (self = [super init]) {
        self.viewControllers = @{UITransitionContextFromViewControllerKey:fromVc,UITransitionContextToViewControllerKey:toVc};
        self.views = @{UITransitionContextFromViewKey:fromVc.view,UITransitionContextToViewKey:toVc.view};
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = aContainerView;
    }
    return self;
}

- (void)setIsRight:(BOOL)aIsRight {
    isRight = aIsRight;
    
    fromViewAppearingFrame = toViewDisappearingFrame = self.containerView.bounds;
    
    CGFloat offsetY = isRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width;
    fromViewDisappearingFrame = CGRectOffset(self.containerView.bounds, offsetY, 0);
    toViewAppearingFrame = CGRectOffset(self.containerView.bounds, -offsetY, 0);
}

-(void)updateInteractiveTransition:(CGFloat)percentComplete {
    containerView.layer.timeOffset = percentComplete;
};

- (void)finishInteractiveTransition{
    transitionWasCancelled = NO;
    
    CFTimeInterval pausedTime = containerView.layer.timeOffset;
    containerView.layer.speed = 1.0;
    containerView.layer.timeOffset = 0.0;
    containerView.layer.beginTime = 0.0;
    CFTimeInterval timeDistance = [containerView.layer convertTime:CACurrentMediaTime() toLayer:nil] - pausedTime;
    containerView.layer.beginTime = timeDistance;
};

- (void)cancelInteractiveTransition{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(toRevokeTransition:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
};

- (void)toRevokeTransition:(CADisplayLink *)displayLink {
    CFTimeInterval timeOffset = containerView.layer.timeOffset - displayLink.duration;
    
    if (timeOffset > 0) {
        containerView.layer.timeOffset = timeOffset;
    }
    else {
        transitionWasCancelled = YES;
        
        [displayLink invalidate];
        
        [containerView addSubview:[self shotFromView]];
        
        containerView.layer.timeOffset = 0;
        containerView.layer.speed = 1.0;
    }
}

- (UIView *)shotFromView {
    UIViewController *fromVc = viewControllers[UITransitionContextFromViewControllerKey];
    shotFromView = [fromVc.view snapshotViewAfterScreenUpdates:NO];
    shotFromView.frame = fromViewAppearingFrame;
    return shotFromView;
}

- (void)completeTransition:(BOOL)didComplete {
    
    if ([delegate respondsToSelector:@selector(OCSliderVCTransitioningContext:transitionCompleted:)]) {
        [delegate OCSliderVCTransitioningContext:self transitionCompleted:didComplete];
    }
    if (self.interactive) {
        [shotFromView removeFromSuperview];
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return viewControllers[key];
}

- (UIView *)viewForKey:(NSString *)key {
    return views[key];
}

- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    if (vc == viewControllers[UITransitionContextFromViewControllerKey]) {
        return fromViewAppearingFrame;
    }
    else {
        return toViewAppearingFrame;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == viewControllers[UITransitionContextFromViewControllerKey]) {
        return  fromViewDisappearingFrame;
    }
    else {
        return  toViewDisappearingFrame;
    }
}

- (void)dealloc {
    [views release];
    [viewControllers release];
    [super dealloc];
    NSLog(@"OCSliderVCTransitioningContext被销毁了");
}

@end

//===============****************************************************=======================//

#pragma mark - OCPrivateInteractiveController

@interface OCPrivateInteractiveController (){
    CGFloat endTranslation;
    CGFloat beginVelocity;
    
    BOOL canTransition;
}

@end

@implementation OCPrivateInteractiveController
@synthesize ocSliderViewController;

- (void)setOcSliderViewController:(OCSliderViewController *)ovc {
    ocSliderViewController = ovc;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tohandlerGes:)];
    [ovc.view addGestureRecognizer:panGes];
    [panGes release];
}

- (void)tohandlerGes:(UIPanGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGFloat beginVy = [ges velocityInView:self.ocSliderViewController.view].x;
        beginVelocity = beginVy;
        
        BOOL isGoRight = beginVelocity<0;

        if ((self.ocSliderViewController.selectedIndex==0 && !isGoRight)||(self.ocSliderViewController.selectedIndex == self.ocSliderViewController.childViewControllers.count-1&&isGoRight)) {
            canTransition = NO;
        }
        else {
            NSInteger toIndex = beginVelocity < 0 ? self.ocSliderViewController.selectedIndex+1 : self.ocSliderViewController.selectedIndex-1;
            UIViewController *toVC = self.ocSliderViewController.childViewControllers[toIndex];
            [self.ocSliderViewController setSelectedViewController:toVC animated:YES];
            canTransition = YES;
        }
    }
    else if (ges.state == UIGestureRecognizerStateChanged) {
        if (canTransition) {
            CGFloat translation = [ges translationInView:self.ocSliderViewController.view].x;
            endTranslation = fabs(translation);
            CGFloat transitionPercent = (fabs(translation)/CGRectGetWidth(self.ocSliderViewController.view.frame))*0.35;
            [self updateInteractiveTransition:transitionPercent];
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded) {
        if (canTransition) {
            CGFloat endVy = [ges velocityInView:self.ocSliderViewController.view].x;
            if (fabs(endVy)>fabs(beginVelocity) && endTranslation > CGRectGetWidth(self.ocSliderViewController.view.frame)*0.1) {
                [self finishInteractiveTransition];
            }
            else if (endTranslation > CGRectGetWidth(self.ocSliderViewController.view.frame)*0.4) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
    }
    else {}
}

@end