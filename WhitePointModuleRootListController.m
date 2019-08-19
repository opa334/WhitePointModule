#include "WhitePointModuleRootListController.h"

@implementation WhitePointModuleRootListController

- (NSArray *)specifiers
{
	if(!_specifiers)
	{
		_specifiers = [self loadSpecifiersFromPlistName:@"ModulePreferences" target:self];
	}

	[self setTitle:[[NSBundle bundleForClass:[self class]] localizedStringForKey:@"CFBundleDisplayName" value:@"Reduce White Point" table:@"InfoPlist"]];

	return _specifiers;
}

@end
