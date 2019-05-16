@interface CCUISliderModuleBackgroundViewController : UIViewController
- (void)setGlyphImage:(id)arg1;
- (void)setGlyphPackageDescription:(id)arg1;
- (void)setGlyphState:(id)arg1;
@end

@class WhitePointModule;

@interface WhitePointModuleBackgroundViewController : CCUISliderModuleBackgroundViewController
@property (nonatomic, weak) WhitePointModule* module;
@end
