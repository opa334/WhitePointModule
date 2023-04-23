#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WhitePointModule.h"

#import "MediaAccessibility.h"
#import "AccessibilityUtilities.h"

#import <ControlCenterUIKit/CCUIModuleSliderView.h>
#import <ControlCenterUI/CCUIModuleInstance.h>
#import <ControlCenterUI/CCUIModuleInstanceManager.h>

@interface CCUIModuleInstanceManager (CCSupport)
- (CCUIModuleInstance*)instanceForModuleIdentifier:(NSString*)moduleIdentifier;
@end

#define kWhitePointIntensityMin 0.25
#define kWhitePointIntensityMax 1.0

//Inside display settings, the intensity can only be changed between 25% and 100%
//Anything under 25% is simply not applied, therefore we have to translate the module percent (0% - 100%) to the actual percent (25%-100%) and back
//There are also constants inside ControlCenterUIKit: kMADisplayFilterPrefReduceWhitePointIntensity(Max/Min), but they both appear to be 0 for some reason so I made my own
CGFloat whitePointIntensityValueForModuleValue(CGFloat moduleValue)
{
	return kWhitePointIntensityMin + moduleValue * (kWhitePointIntensityMax - kWhitePointIntensityMin);
}

CGFloat moduleValueForWhitePointIntensityValue(CGFloat whitePointIntensityValue)
{
	return (whitePointIntensityValue - kWhitePointIntensityMin) / (kWhitePointIntensityMax - kWhitePointIntensityMin);
}

CGFloat reversedModuleValueForValue(CGFloat moduleValue)
{
	return -moduleValue + 1.0;
}

@implementation WhitePointModule

- (instancetype)init
{
	self = [super init];

	_contentViewController = [[WhitePointModuleContentViewController alloc] init];
	_contentViewController.module = self;

	_backgroundViewController = [[WhitePointModuleBackgroundViewController alloc] init];
	_backgroundViewController.module = self;

	_ignoreUpdates = NO;

	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.opa334.whitepointmodule"];

	[self updatePrefs];

	return self;
}

- (UIViewController*)contentViewController
{
	return _contentViewController;
}

- (UIViewController*)backgroundViewController
{
	return _backgroundViewController;
}

- (void)updatePrefs
{
	_invertPercententageEnabled = [_preferences boolForKey:@"invertSliderEnabled"];
	[self updateState];
}

- (void)updateState
{
	if(!_ignoreUpdates)
	{
		BOOL currentState = [AXSettings sharedInstance].reduceWhitePointEnabled;
		[_contentViewController setSelected:currentState];

		CGFloat moduleValue = moduleValueForWhitePointIntensityValue(MADisplayFilterPrefGetReduceWhitePointIntensity());

		if(_invertPercententageEnabled)
		{
			moduleValue = reversedModuleValueForValue(moduleValue);
		}

		_contentViewController.sliderView.value = moduleValue;
	}
}

- (void)applyState
{
	_ignoreUpdates = YES;

	BOOL newState = [_contentViewController isSelected];
	[AXSettings sharedInstance].reduceWhitePointEnabled = newState;

	CGFloat moduleValue = _contentViewController.sliderView.value;

	if(_invertPercententageEnabled)
	{
		moduleValue = reversedModuleValueForValue(moduleValue);
	}

	CGFloat newIntensity = whitePointIntensityValueForModuleValue(moduleValue);
	MADisplayFilterPrefSetReduceWhitePointIntensity(newIntensity);
	//RE: How did you find this function?
	//I reversed the PreferenceBundle of the accessibility settings and saw that it was calling it (probably... I don't know for sure)

	_ignoreUpdates = NO;
}

@end

void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	CCUIModuleInstance* wpModuleInstance = [[NSClassFromString(@"CCUIModuleInstanceManager") sharedInstance] instanceForModuleIdentifier:@"com.opa334.whitepointmodule"];
	[(WhitePointModule*)wpModuleInstance.module updatePrefs];
}

void displayFilterSettingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	CCUIModuleInstance* wpModuleInstance = [[NSClassFromString(@"CCUIModuleInstanceManager") sharedInstance] instanceForModuleIdentifier:@"com.opa334.whitepointmodule"];
	[(WhitePointModule*)wpModuleInstance.module updateState];
}

__attribute__((constructor))
static void init(void)
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayFilterSettingsChanged, CFSTR("com.apple.mediaaccessibility.displayFilterSettingsChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	//RE: How did you figure this key out?
	//I hooked CFNotificationCenterPostNotification in Preferences.app with a log and toggled the option inside settings, this should work for any other option too

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, prefsChanged, CFSTR("com.opa334.whitepointmodule/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
