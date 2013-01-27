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
#import "VideoBankSimPlayer.h"
#import "VideoBankRecorder.h"
#import "LiveMixer.h"
#import "Filters.h"
#import "Masking.h"
#import "QLabController.h"
#import "MIDIReceiver.h"

#import "VideoPlayerView.h"

#import "OutputWindow.h"

#import "BlackMagicController.h"

#import "MAVController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    int _outSelector;

}

@property (assign) IBOutlet NSWindow *window;

@property VideoBank * videoBank;
@property VideoBankPlayer * videoBankPlayer;
@property VideoBankSimPlayer * videoBankSimPlayer;
@property VideoBankRecorder * videoBankRecorder;

@property LiveMixer * liveMixer1;
@property LiveMixer * liveMixer2;
@property LiveMixer * liveMixer3;

@property Filters * filters;
@property Masking * masking;
@property BlackMagicController * blackMagicController;
@property QLabController * qlab;
@property MIDIReceiver * midiReceiver;
@property (weak) IBOutlet NSSegmentedControl *moviePlayerSegmentControl;

@property MavController * mavController;
@property (readwrite) int outSelector;
@property (readwrite) int decklink1input;
@property (readwrite) int decklink2input;
@property (readwrite) int decklink3input;


@property (weak) IBOutlet OutputWindow * outputWindow;

@property (weak) IBOutlet VideoPlayerView *previewView;
@property (weak) IBOutlet CoreImageViewer *livePreview1;
@property (weak) IBOutlet CoreImageViewer *livePreview2;
@property (weak) IBOutlet CoreImageViewer *livePreview3;

@end
