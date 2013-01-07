//
//  AppDelegate.m
//  SH
//
//  Created by Jonas Jongejan on 06/01/13.
//  Copyright (c) 2013 HalfdanJ. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.videoBank = [[VideoBank alloc] initWithNumberBanks:3];
    self.videoBank.videoPreviewView = self.previewView;
    
    [self.outputWindow orderFront:self];
    
    self.videoBankPlayer = [[VideoBankPlayer alloc] init];
    self.videoBankPlayer.videoBank = self.videoBank;
    
    self.videoBankPlayer.layer.frame = self.outputWindow.imageViewer.layer.frame;
    [self.outputWindow.imageViewer.layer addSublayer:self.videoBankPlayer.layer];
    
}

@end
