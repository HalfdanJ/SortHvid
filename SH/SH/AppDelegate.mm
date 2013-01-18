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
    
    self.midiReceiver = [[MIDIReceiver alloc] init];

    self.blackMagicController = [[BlackMagicController alloc] initWithNumItems:3];
    
    self.filters = [[Filters alloc] init];
    [self.outputWindow bind:@"filters" toObject:self.filters withKeyPath:@"filters" options:nil];
    
    [self.filters addObserver:self.outputWindow forKeyPath:@"filters" options:0 context:nil];
    

    
    self.videoBank = [[VideoBank alloc] initWithNumberBanks:50];
    self.videoBank.videoPreviewView = self.previewView;
    
    ////------
    self.videoBankPlayer = [[VideoBankPlayer alloc] initWithBank:self.videoBank];
    
    self.videoBankPlayer.layer.frame = self.outputWindow.layer.frame;
    [self.outputWindow.layer addSublayer:self.videoBankPlayer.layer];
    
    ////------
    self.videoBankSimPlayer = [[VideoBankSimPlayer alloc] initWithBank:self.videoBank];
    
    self.videoBankSimPlayer.layer.frame = self.outputWindow.layer.frame;
    [self.outputWindow.layer addSublayer:self.videoBankSimPlayer.layer];

    
    self.liveMixer = [[LiveMixer alloc] init];
    [self.liveMixer bind:@"input1" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:0];
    [self.liveMixer bind:@"input2" toObject:[self.blackMagicController.items objectAtIndex:1] withKeyPath:@"inputImage" options:0];
    [self.liveMixer bind:@"input3" toObject:[self.blackMagicController.items objectAtIndex:2] withKeyPath:@"inputImage" options:0];
    
    [self.outputWindow.imageViewer bind:@"ciImage" toObject:self.liveMixer withKeyPath:@"output" options:0];
    
    self.masking = [[Masking alloc] init];
    self.masking.maskingLayer.frame = self.outputWindow.layer.frame;
    [self.outputWindow.layer addSublayer:self.masking.maskingLayer];

    
    
    self.qlab = [[QLabController alloc] init];
    
    
    ////------
    
    
    self.videoBankRecorder = [[VideoBankRecorder alloc] initWithBlackmagicItems:self.blackMagicController.items bank:self.videoBank];

    [self.livePreview1 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:nil];
    self.livePreview1.delegate = self.liveMixer;
    self.livePreview1.customData = @(1);
    [self.livePreview1 bind:@"highlight" toObject:self.liveMixer withKeyPath:@"input1Selected" options:nil];
    [self.livePreview1 bind:@"recordHighlight" toObject:self.videoBankRecorder withKeyPath:@"device1Selected" options:nil];

    [self.livePreview2 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:1] withKeyPath:@"inputImage" options:nil];
    self.livePreview2.delegate = self.liveMixer;
    self.livePreview2.customData = @(2);
    [self.livePreview2 bind:@"highlight" toObject:self.liveMixer withKeyPath:@"input2Selected" options:nil];
    [self.livePreview2 bind:@"recordHighlight" toObject:self.videoBankRecorder withKeyPath:@"device2Selected" options:nil];
    
    CIFilter * filter = [CIFilter filterWithName:@"CIAffineTransform"];
    NSAffineTransform * transform = [NSAffineTransform transform];
    [transform scaleBy:720/1920.0];
    [filter setValue:transform forKey:@"inputTransform"];
    self.livePreview2.filters = @[filter];
    

    [self.livePreview3 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:2] withKeyPath:@"inputImage" options:nil];
    self.livePreview3.delegate = self.liveMixer;
    self.livePreview3.customData = @(3);
    [self.livePreview3 bind:@"highlight" toObject:self.liveMixer withKeyPath:@"input3Selected" options:nil];
    [self.livePreview3 bind:@"recordHighlight" toObject:self.videoBankRecorder withKeyPath:@"device3Selected" options:nil];

    
    
    [self.window orderFront:self];
    
       
    
    
}


-(void)applicationWillTerminate:(NSNotification *)notification{
    [BeamSync enable];
}


/*
 -(IBAction)readPasteboard:(id)sender{
 
 NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
 NSArray *classes = [[NSArray alloc] initWithObjects:[NSAttributedString class], [NSString class], nil];
 NSDictionary *options = [NSDictionary dictionary];
 NSArray *copiedItems = [pasteboard readObjectsForClasses:classes options:options];
 
 
 NSPasteboardItem * item = [pasteboard pasteboardItems][0];
 NSLog(@"Pasteboard types %@",[pasteboard types]);
 
 CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassNSPboardType, CFSTR("Cue"), kUTTypeData);
 NSLog(@"UTI %@",uti);
 
 NSMutableDictionary * propertyList = [[item propertyListForType:item.types[0]] mutableCopy];
 NSMutableArray * objects =[[propertyList objectForKey:@"$objects"] mutableCopy];
 //NSLog(@"Pasteboard %@",[propertyList objectForKey:@"$objects"]);
 
 int i=0;
 for(id obj in objects){
 NSLog(@"\n\n %i: \n%@",i++,obj);
 }
 
 objects[6] = @"oapsdkpoaskd";
 
 [propertyList setObject:objects forKey:@"$objects"];
 
 
 [pasteboard clearContents];
 
 [pasteboard addTypes:@[@"Cue"] owner:nil];
 [pasteboard setPropertyList:propertyList forType:@"Cue"];
 
 
 }
 */



@end
