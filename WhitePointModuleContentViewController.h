#import <ControlCenterUIKit/CCUIButtonModuleViewController.h>

@class WhitePointModule, CCUIModuleSliderView;

@interface WhitePointModuleContentViewController : CCUIButtonModuleViewController
@property (nonatomic, weak) WhitePointModule* module;
@property (nonatomic) CCUIModuleSliderView* sliderView;
@end
