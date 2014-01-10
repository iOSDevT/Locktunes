#include "substrate.h"

#import <UIKit/UIKit.h>
#import <SpringBoard/SBLockScreenViewController.h>
#import <SpringBoard/SBBacklightController.h>
#import <SpringBoard/SBLockScreenView.h>

#import <MediaPlayer/MediaPlayer.h>

MPMusicPlayerController *musicPlayer;
id delegate;
id scrollView;
int width;
BOOL shouldKeepAwake;
BOOL enabled = YES;

%hook SBLockScreenView

- (void)_layoutForegroundView {
	%orig;
	if (enabled) {
		NSLog(@" [*] Locktunes: _layoutForegroundView!");
		scrollView = MSHookIvar<id>(self, "_foregroundScrollView");
		delegate = MSHookIvar<id>(self, "_delegate");
		NSLog(@" [*] Locktunes: scrollView: %@", scrollView);	
		musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
		mediaPicker.allowsPickingMultipleItems = YES;
		mediaPicker.prompt = @"Select songs to play";
		mediaPicker.delegate = (id)self;
		[mediaPicker.view setFrame:CGRectMake([scrollView contentSize].width, 20, mediaPicker.view.frame.size.width, mediaPicker.view.frame.size.height)];
		[scrollView addSubview:mediaPicker.view];
		[delegate _adjustIdleTimerForEmergencyDialerActive:YES];
		shouldKeepAwake = NO;
		[self setTopBottomGrabbersHidden:YES forRequester:self];
		CGSize size = CGSizeMake([scrollView contentSize].width + mediaPicker.view.frame.size.width, [scrollView contentSize].height);
		width = [scrollView contentSize].width / 2;
		[scrollView setContentSize:size];
	}
}

%new
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    if (mediaItemCollection) {
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
	CGPoint point = CGPointMake(width, 0);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	[scrollView setContentOffset:point];
	[UIView commitAnimations];
	shouldKeepAwake = NO;
}

%new
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	CGPoint point = CGPointMake(width, 0);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.25];
	[scrollView setContentOffset:point];
	[UIView commitAnimations];
	shouldKeepAwake = NO;
}

%end


%hook SBLockScreenViewController
- (void)lockScreenView:(id)arg1 didEndScrollingOnPage:(long long)arg2 {
	%orig;
	if (enabled) {
		if ([scrollView contentOffset].x > 639) {
			shouldKeepAwake = YES;
		} else {
	 	shouldKeepAwake = NO;
		}
	}
}
-(BOOL)isMakingEmergencyCall { if (enabled) { return shouldKeepAwake; } else { return %orig; } }
%end

static void LocktunesPrefsLoad() {
	NSDictionary *enabledDict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.banditlabs.locktunes.plist"];
	enabled = [[enabledDict valueForKey:@"Enabled"] boolValue];
}

%ctor {
	LocktunesPrefsLoad();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LocktunesPrefsLoad, CFSTR("com.banditlabs.locktunes.settingschanged"), NULL, 0);
}
