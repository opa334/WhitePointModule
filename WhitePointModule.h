#import "WhitePointModuleBackgroundViewController.h"
#import "WhitePointModuleContentViewController.h"

#import <ControlCenterUIKit/CCUIContentModule.h>

extern CGFloat whitePointIntensityValueForModuleValue(CGFloat moduleValue);
extern CGFloat moduleValueForWhitePointIntensityValue(CGFloat whitePointIntensityValue);

@interface WhitePointModule : NSObject <CCUIContentModule>
{
	NSUserDefaults* _preferences;
	BOOL _ignoreUpdates;
	BOOL _invertPercententageEnabled;
	WhitePointModuleBackgroundViewController* _backgroundViewController;
	WhitePointModuleContentViewController* _contentViewController;
}
- (void)updateState;
- (void)applyState;
@end
