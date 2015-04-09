//
//  DeveloperLx
//  LxNavigationController.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LxNavigationControllerInteractionStopReason) {
    LxNavigationControllerInteractionStopReasonFinished,
    LxNavigationControllerInteractionStopReasonCancelled,
    LxNavigationControllerInteractionStopReasonFailed,
};

@interface LxNavigationController : UINavigationController

@property (nonatomic,assign) BOOL popGestureRecognizerEnable;
@property (nonatomic,assign) BOOL recognizeOtherGestureSimultaneously;
@property (nonatomic,readonly) BOOL isTranslating;
@property (nonatomic,copy) void (^popGestureRecognizerBeginBlock)();
@property (nonatomic,copy) void (^popGestureRecognizerStopBlock)(LxNavigationControllerInteractionStopReason stopReason);

@end
