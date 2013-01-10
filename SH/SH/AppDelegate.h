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
#import "VideoBankRecorder.h"

#import "VideoPlayerView.h"

#import "OutputWindow.h"

#import "BlackMagicController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property VideoBank * videoBank;
@property VideoBankPlayer * videoBankPlayer;
@property VideoBankRecorder * videoBankRecorder;
@property BlackMagicController * blackMagicController;

@property (weak) IBOutlet OutputWindow * outputWindow;

@property (weak) IBOutlet VideoPlayerView *previewView;
@property (weak) IBOutlet CoreImageViewer *livePreview1;

@end
