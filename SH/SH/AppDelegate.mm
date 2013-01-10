//
//  AppDelegate.m
//  SH
//
//  Created by Jonas Jongejan on 06/01/13.
//  Copyright (c) 2013 HalfdanJ. All rights reserved.
//

#import "AppDelegate.h"
#import "BeamSync.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BeamSync disable];
    
    self.videoBank = [[VideoBank alloc] initWithNumberBanks:3];
    self.videoBank.videoPreviewView = self.previewView;
    
    
    self.videoBankPlayer = [[VideoBankPlayer alloc] init];
    self.videoBankPlayer.videoBank = self.videoBank;
    
    self.videoBankPlayer.layer.frame = self.outputWindow.layer.frame;
    [self.outputWindow.layer addSublayer:self.videoBankPlayer.layer];
    
    self.blackMagicController = [[BlackMagicController alloc] init];
    
    [self.outputWindow.imageViewer bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:0];
    
    [self.livePreview1 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:nil];
    
    self.videoBankRecorder = [[VideoBankRecorder alloc] initWithBlackmagicItems:self.blackMagicController.items];
    self.videoBankRecorder.videoBank = self.videoBank;
}

-(void)applicationWillTerminate:(NSNotification *)notification{
    [BeamSync enable];
}

@end
