#import "WhitePointModuleBackgroundViewController.h"
#import "WhitePointModuleContentViewController.h"

#import <ControlCenterUIKit/CCUIContentModule.h>

extern CGFloat whitePointIntensityValueForModuleValue(CGFloat moduleValue);
extern CGFloat moduleValueForWhitePointIntensityValue(CGFloat whitePointIntensityValue);

@interface WhitePointModule : NSObject <CCUIContentModule>
{
	BOOL _ignoreUpdates;
	WhitePointModuleBackgroundViewController* _backgroundViewController;
	WhitePointModuleContentViewController* _contentViewController;
}
- (void)updateState;
- (void)applyState;
@end
