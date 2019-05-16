#import "WhitePointModuleBackgroundViewController.h"

#import "WhitePointModule.h"

@implementation WhitePointModuleBackgroundViewController

- (instancetype)init
{
	return [self initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	self.glyphImage = [UIImage imageNamed:@"IconDisabled" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

	return self;
}

@end
