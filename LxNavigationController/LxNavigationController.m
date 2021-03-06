//
//  DeveloperLx
//  LxNavigationController.m
//

#import "LxNavigationController.h"

static NSTimeInterval const POP_ANIMATION_DURATION = 0.2;
static CGFloat const MIN_VALID_PROPORTION = 0.42;

@interface PopTransition : NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation PopTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return POP_ANIMATION_DURATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [transitionContext.containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    CGRect toViewControllerViewFrame = toViewController.view.frame;
    toViewControllerViewFrame.origin.x = -toViewControllerViewFrame.size.width/2;
    toViewController.view.frame = toViewControllerViewFrame;
    toViewControllerViewFrame.origin.x = 0;
    
    toViewController.view.alpha = fromViewController.view.alpha - 0.2;
    
    [UIView animateWithDuration:POP_ANIMATION_DURATION animations:^{
        fromViewController.view.frame = CGRectMake(fromViewController.view.frame.size.width, fromViewController.view.frame.origin.y, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height);
        toViewController.view.frame = toViewControllerViewFrame;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end


#pragma mark - LxNavigationController

@interface LxNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation LxNavigationController
{
    UIPanGestureRecognizer * _popGestureRecognizer;
    UIPercentDrivenInteractiveTransition * _interactivePopTransition;
}
@synthesize isTranslating = _isTranslating;

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.enabled = NO;
    _popGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(popGestureRecognizerTriggerd:)];
    _popGestureRecognizer.delegate = self;
    _popGestureRecognizer.cancelsTouchesInView = NO;
    _popGestureRecognizer.maximumNumberOfTouches = 1;
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:_popGestureRecognizer];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[PopTransition class]]) {
        return _interactivePopTransition;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return [[PopTransition alloc]init];
    }
    else {
        return nil;
    }
}

#pragma mark - gesture

- (void)setPopGestureRecognizerEnable:(BOOL)popGestureRecognizerEnable
{
    _popGestureRecognizer.enabled = popGestureRecognizerEnable;
}

- (BOOL)popGestureRecognizerEnable
{
    return _popGestureRecognizer.enabled;
}

- (void)popGestureRecognizerTriggerd:(UIPanGestureRecognizer *)popPan
{
    CGFloat progress = [popPan translationInView:popPan.view].x / popPan.view.bounds.size.width;
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (popPan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isTranslating = YES;
            _interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
            [self popViewControllerAnimated:YES];
            if (self.popGestureRecognizerBeginBlock) {
                self.popGestureRecognizerBeginBlock();
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [_interactivePopTransition updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            _isTranslating = NO;
            if (self.popGestureRecognizerStopBlock) {
                self.popGestureRecognizerStopBlock(LxNavigationControllerInteractionStopReasonFailed);
            }
        }
            break;
        default:
        {
            if (progress > MIN_VALID_PROPORTION) {
                [_interactivePopTransition finishInteractiveTransition];
                if (self.popGestureRecognizerStopBlock) {
                    self.popGestureRecognizerStopBlock(LxNavigationControllerInteractionStopReasonFinished);
                }
            }
            else {
                [_interactivePopTransition cancelInteractiveTransition];
                if (self.popGestureRecognizerStopBlock) {
                    self.popGestureRecognizerStopBlock(LxNavigationControllerInteractionStopReasonCancelled);
                }
            }
            _interactivePopTransition = nil;
            _isTranslating = NO;
        }
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _popGestureRecognizer) {
        CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat translationX = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x;
        if (location.x > gestureRecognizer.view.frame.size.width * MIN_VALID_PROPORTION || translationX < 0 || self.viewControllers.count < 2) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == _popGestureRecognizer || otherGestureRecognizer == _popGestureRecognizer) {
        return self.recognizeOtherGestureSimultaneously;
    }
    else {
        return NO;
    }
}

#pragma mark - 

- (BOOL)isTranslating
{
    return _isTranslating;
}

- (UIViewController *)rootViewController
{
    return self.viewControllers.firstObject;
}

@end
