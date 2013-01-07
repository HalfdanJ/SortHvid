//
//  AppDelegate.h
//  SH
//
//  Created by Jonas Jongejan on 06/01/13.
//  Copyright (c) 2013 HalfdanJ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "VideoBank.h"
#import "VideoPlayerView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property VideoBank * videoBank;
@property (weak) IBOutlet VideoPlayerView *previewView;

@end
