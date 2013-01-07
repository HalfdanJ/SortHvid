//
//  AppDelegate.h
//  SH
//
//  Created by Jonas Jongejan on 06/01/13.
//  Copyright (c) 2013 HalfdanJ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VideoBank.h"
#import "VideoBankPlayer.h"
#import "VideoPlayerView.h"
#import "OutputWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property VideoBank * videoBank;
@property VideoBankPlayer * videoBankPlayer;

@property (weak) IBOutlet OutputWindow * outputWindow;

@property (weak) IBOutlet VideoPlayerView *previewView;

@end
