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

    self.blackMagicController = [[BlackMagicController alloc] initWithModes:@[@(2),@(2),@(2)]];
    
    self.filters = [[Filters alloc] init];
    [self.outputWindow bind:@"filters" toObject:self.filters withKeyPath:@"filters" options:nil];
    
    [self.filters addObserver:self.outputWindow forKeyPath:@"filters" options:0 context:nil];
    

    
    self.videoBank = [[VideoBank alloc] initWithNumberBanks:50];
    self.videoBank.videoPreviewView = self.previewView;
    
    ////------
    self.videoBankPlayer = [[VideoBankPlayer alloc] initWithBank:self.videoBank];
    self.videoBankPlayer.segmentControl = self.moviePlayerSegmentControl;
    
    
    self.videoBankPlayer.layer1.frame = self.outputWindow.layer1.frame;
    [self.outputWindow.layer1 addSublayer:self.videoBankPlayer.layer1];

    self.videoBankPlayer.layer2.frame = self.outputWindow.layer1.frame;
    [self.outputWindow.layer2 addSublayer:self.videoBankPlayer.layer2];

    self.videoBankPlayer.layer3.frame = self.outputWindow.layer1.frame;
    [self.outputWindow.layer3 addSublayer:self.videoBankPlayer.layer3];

    ////------

    for(int i=0;i<3;i++){
        LiveMixer * mixer;
        mixer = [[LiveMixer alloc] initWithNum:i];
        [mixer bind:@"input1" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:0];
        [mixer bind:@"input2" toObject:[self.blackMagicController.items objectAtIndex:1] withKeyPath:@"inputImage" options:0];
        [mixer bind:@"input3" toObject:[self.blackMagicController.items objectAtIndex:2] withKeyPath:@"inputImage" options:0];
        
        if(i != 0){
            [mixer bind:@"crossfade" toObject:self.liveMixer1 withKeyPath:@"crossfade" options:nil];
            [mixer bind:@"opacity" toObject:self.liveMixer1 withKeyPath:@"opacity" options:nil];
        }
        

        if(i==0)
            self.liveMixer1 = mixer;
        if(i==1)
            self.liveMixer2 = mixer;
        if(i==2)
            self.liveMixer3 = mixer;
        
        
        if(i==0)
            [self.outputWindow.imageViewer1 bind:@"ciImage" toObject:self.liveMixer1 withKeyPath:@"output" options:0];
        if(i==1)
            [self.outputWindow.imageViewer2 bind:@"ciImage" toObject:self.liveMixer2 withKeyPath:@"output" options:0];
        if(i==2)
            [self.outputWindow.imageViewer3 bind:@"ciImage" toObject:self.liveMixer3 withKeyPath:@"output" options:0];
    }
    
    self.masking = [[Masking alloc] init];
    self.masking.maskingLayer.frame = self.outputWindow.layer1.frame;
    [self.outputWindow.layer1 addSublayer:self.masking.maskingLayer];

    
    
    self.qlab = [[QLabController alloc] init];
    
    
    ////------
    
    
    self.videoBankRecorder = [[VideoBankRecorder alloc] initWithBlackmagicItems:self.blackMagicController.items bank:self.videoBank];

    [self.livePreview1 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:0] withKeyPath:@"inputImage" options:nil];

    [self.livePreview2 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:1] withKeyPath:@"inputImage" options:nil];
    
   /* CIFilter * filter = [CIFilter filterWithName:@"CIAffineTransform"];
    NSAffineTransform * transform = [NSAffineTransform transform];
    [transform scaleBy:720/1920.0];
    [filter setValue:transform forKey:@"inputTransform"];
    self.livePreview2.filters = @[filter];
    */

    [self.livePreview3 bind:@"ciImage" toObject:[self.blackMagicController.items objectAtIndex:2] withKeyPath:@"inputImage" options:nil];

    
    
    [self.window orderFront:self];
    
    
    self.mavController = [[MavController alloc] init];

    self.decklink1input = -1;
    self.decklink2input = -1;
    self.decklink3input = -1;
    [self.mavController.outputPatch[0] bind:@"input" toObject:self withKeyPath:@"decklink1input" options:nil];
    [self.mavController.outputPatch[1] bind:@"input" toObject:self withKeyPath:@"decklink2input" options:nil];
    [self.mavController.outputPatch[2] bind:@"input" toObject:self withKeyPath:@"decklink3input" options:nil];
    
    //    [self addObserver:self forKeyPath:@"decklink1input" options:0 context:nil];
    for(int i=0;i<3;i++){
        [self.mavController.outputPatch[i] addObserver:self forKeyPath:@"input" options:0 context:(void*)@(i)];
    }
    
    [self.mavController readAllOutputs];

    [globalMidi addBindingTo:self path:@"decklink1input" channel:1 number:60 rangeMin:0 rangeLength:127];
    [globalMidi addBindingTo:self path:@"decklink2input" channel:1 number:61 rangeMin:0 rangeLength:127];
    [globalMidi addBindingTo:self path:@"decklink2input" channel:1 number:62 rangeMin:0 rangeLength:127];
    
}


-(void)applicationWillTerminate:(NSNotification *)notification{
    [BeamSync enable];
}

-(void)setOutSelector:(int)outSelector{
    [self willChangeValueForKey:@"out1selected"];
    [self willChangeValueForKey:@"out2selected"];
    [self willChangeValueForKey:@"out3selected"];
    
    _outSelector = outSelector;
    
    [self didChangeValueForKey:@"out1selected"];
    [self didChangeValueForKey:@"out2selected"];
    [self didChangeValueForKey:@"out3selected"];
    
}

-(int)outSelector{
    return _outSelector;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"input"]){
        NSNumber * output = (__bridge NSNumber*) context;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([output intValue] == 0){
                self.decklink1input = [[object valueForKey:@"input"] intValue];               
            }
            if([output intValue] == 1){
                self.decklink2input = [[object valueForKey:@"input"] intValue];               
            }
            if([output intValue] == 2){
                self.decklink3input = [[object valueForKey:@"input"] intValue];               
            }
        });
    }
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
-(void)qlabMatrix1{
    NSArray * cues = @[
    @{QName : [NSString stringWithFormat:@"Input 1: %i", self.decklink1input+1], QPath: @"decklink1input"},
    ];
    
    NSString * title = [NSString stringWithFormat:@"Input 1: %i",self.decklink1input+1];
    
    [QLabController createCues:cues groupTitle:title sender:self];
}
-(void)qlabMatrix2{
    NSArray * cues = @[
    @{QName : [NSString stringWithFormat:@"Input 2: %i", self.decklink2input+1], QPath: @"decklink2input"},
    ];
    
    NSString * title = [NSString stringWithFormat:@"Input 1: %i",self.decklink2input+1];
    
    [QLabController createCues:cues groupTitle:title sender:self];
}
-(void)qlabMatrix3{
    NSArray * cues = @[
    @{QName : [NSString stringWithFormat:@"Input 3: %i", self.decklink3input+1], QPath: @"decklink3input"},
    ];
    
    NSString * title = [NSString stringWithFormat:@"Input 1: %i",self.decklink3input+1];
    
    [QLabController createCues:cues groupTitle:title sender:self];
}


@end
