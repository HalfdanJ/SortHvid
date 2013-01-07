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
    self.videoBank = [[VideoBank alloc] initWithNumberBanks:2];
    self.videoBank.videoPreviewView = self.previewView;
}

@end
