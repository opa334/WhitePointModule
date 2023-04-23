#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WhitePointModuleContentViewController.h"

#import "WhitePointModule.h"
#import "ControlCenterUIKit.h"

#import <ControlCenterUIKit/CCUIModuleSliderView.h>
#import <ControlCenterUIKit/CCUIButtonModuleView.h>

@interface UIView (Private)
@property (setter=_setContinuousCornerRadius:, nonatomic) CGFloat _continuousCornerRadius;
@end

@interface CCUIModuleSliderView (iOS12)
@property (assign,nonatomic) CGFloat continuousSliderCornerRadius;
@end

@interface CCUIContinuousSliderView : CCUIModuleSliderView //not actually a subclass of CCUIModuleSliderView, this is just to make it compile
@end

@implementation WhitePointModuleContentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

	self.glyphImage = [UIImage imageNamed:@"IconDisabled" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
	self.selectedGlyphImage = [UIImage imageNamed:@"IconEnabled" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
	self.selectedGlyphColor = [UIColor grayColor];

	return self;
}

- (CGFloat)preferredExpandedContentHeight
{
	return CCUISliderExpandedContentModuleHeight();
}

- (CGFloat)preferredExpandedContentWidth
{
	return CCUISliderExpandedContentModuleWidth();
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	if(NSClassFromString(@"CCUIContinuousSliderView")) //iOS 13
	{
		self.sliderView = [[NSClassFromString(@"CCUIContinuousSliderView") alloc] initWithFrame:self.view.bounds];
	}
	else //iOS 12 and below
	{
		self.sliderView = [[CCUIModuleSliderView alloc] initWithFrame:self.view.bounds];
	}

	self.sliderView.glyphVisible = YES;
	[self.sliderView addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
	[self.module updateState];

	[self.view addSubview:self.sliderView];
}

- (void)viewWillLayoutSubviews	//Behaves just like the flashlight module
{
	[super viewWillLayoutSubviews];

	CGFloat cornerRadius = 0;

	if(self.expanded)
	{
		self.buttonView.alpha = 0.0;
		self.sliderView.alpha = 1.0;
		cornerRadius = CCUIExpandedModuleContinuousCornerRadius();
	}
	else
	{
		self.sliderView.alpha = 0.0;
		self.buttonView.alpha = 1.0;
		cornerRadius = CCUICompactModuleContinuousCornerRadius();
	}

	self.sliderView._continuousCornerRadius = cornerRadius;

	if([self.sliderView respondsToSelector:@selector(setContinuousSliderCornerRadius:)])	//iOS 12
	{
		self.sliderView.continuousSliderCornerRadius = cornerRadius;
	}

	self.sliderView.frame = self.view.bounds;
}

//Dirty fix for layout bugs when long pressing, actually not so dirty because apple uses the same fix... for all of their expandable modules...
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	self.buttonView.enabled = !self.expanded;

	[coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext>context)
	{
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	} completion:nil];
}

- (void)buttonTapped:(id)arg1 forEvent:(id)arg2
{
	BOOL newState = ![self isSelected];
	[self setSelected:newState];

	[self.module applyState];
}

- (void)_sliderValueDidChange:(id)sender
{
	[self.module applyState];
}

- (BOOL)isGroupRenderingRequired
{
	return self.sliderView.isGroupRenderingRequired;
}

- (CALayer *)punchOutRootLayer
{
	return self.sliderView.punchOutRootLayer;
}

- (BOOL)_canShowWhileLocked
{
	return YES;
}

@end
