#import <Preferences/Preferences.h>

@interface LocktunesListController: PSListController {
}
@end

@implementation LocktunesListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Locktunes" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
