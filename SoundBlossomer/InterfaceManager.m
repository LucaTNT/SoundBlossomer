//
//  InterfaceManager.m
//  SoundBlossomer
//
//  Created by Luca Zorzi on 26/12/12.
//  Copyright (c) 2012 Luca Zorzi. All rights reserved.
//

#import "InterfaceManager.h"
#import <SecurityFoundation/SFAuthorization.h>

@implementation InterfaceManager
@synthesize interfaces;

-(id)init
{
    plistPath = @"/System/Library/Extensions/Soundflower.kext/Contents/Info.plist";
    if(![[NSFileManager alloc] fileExistsAtPath:plistPath isDirectory:false])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Soundflower not found"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"SoundBlossomer was not able to locate Soundflower on your Mac, make sure it is installed correctly."];
        [alert runModal];
        exit(1);
    }
    return [super init];
}


-(NSArray *)getInterfaces
{
    originalPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *audioEngines = originalPlist[@"IOKitPersonalities"][@"PhantomAudioDriver"][@"AudioEngines"];

    self.interfaces = @[].mutableCopy;
    
    for (NSDictionary *engine in audioEngines)
    {

        for(NSDictionary *format in engine[@"Formats"])
        {
            [self addInterfaceWithName:engine[@"Description"] withChannelNumber:format[@"IOAudioStreamNumChannels"]];
        }
        
}


    return [self interfaces];
}

// Sets the channel number for a given audio interface
-(void)setChannelNumber:(id)newChannelNumber atIndex:(NSInteger)row
{
    // For safety's sake, we copy the old values off the array
    NSString *interfaceName = [[interfaces objectAtIndex:row] objectForKey:@"interfaceName"];

    
    [interfaces replaceObjectAtIndex:row withObject:@{@"interfaceName" : interfaceName,
                                                      @"channelNumber" : newChannelNumber}];
}

// Sets the name for a given audio interface
-(void)setInterfaceName:(id)newInterfaceName atIndex:(NSInteger)row
{
    // For safety's sake, we copy the old values off the array
    NSString *channelNumber = [[interfaces objectAtIndex:row] objectForKey:@"channelNumber"];
    
    
    [interfaces replaceObjectAtIndex:row withObject:@{@"interfaceName" : newInterfaceName,
                                                      @"channelNumber" : channelNumber}];
}

// Guess what this does
-(NSInteger)countInterfaces
{
    return [[self interfaces] count];
}

// If you're smart enough, you can figure this out
-(void)addInterfaceWithName:(NSString *)interfaceName withChannelNumber:(id)channelNumber
{
    [[self interfaces] addObject:@{@"interfaceName" : interfaceName,
                                   @"channelNumber" : channelNumber}];

}

// I'm tired of writing pointless comments.
-(void)removeInterfaceAtIndex:(NSInteger)row
{
    [[self interfaces] removeObjectAtIndex:row];
}


-(void)makePlist
{
    // Make a mutable copy of the original plist so that we can work with it
    editedPlist = originalPlist.mutableCopy;
    
    // Create an empty mutable array for our engines (aka audio interfaces) so that we can fill it
    NSMutableArray *engines = @[].mutableCopy;
    
    // Static array which is needed for every interface
    NSArray *sampleRates = @[@44100, @48000, @88200, @96000, @176400, @192000];
    
    // Cycle through the currently definied interfaces and add them to the engines array
    for (NSDictionary *currentInterface in [self interfaces])
    {
        // This structure is mandated by the original plist. We only edit the interface name and the number of channels
        NSDictionary *engine = @{@"BlockSize" : @8192,
                                 @"Description" : [currentInterface objectForKey:@"interfaceName"],
                                 @"Formats" : @[ @{@"IOAudioStreamAlignment" : @1,
                                                   @"IOAudioStreamBitDepth" :  @32,
                                                   @"IOAudioStreamBitWidth" : @32,
                                                   @"IOAudioStreamByteOrder" : @0,
                                                   @"IOAudioStreamDriverTag" : @0,
                                                   @"IOAudioStreamIsMixable" : @1,
                                                   @"IOAudioStreamNumChannels" : @([[currentInterface objectForKey:@"channelNumber"] integerValue]),
                                                   @"IOAudioStreamNumericRepresentation" : @1936289396,
                                                   @"IOAudioStreamSampleFormat" : @1819304813
                                                   }
                                                 ],
                                 @"NumBlocks" : @2,
                                 @"NumStreams" : @1,
                                 @"SampleRates" : sampleRates};
        
        [engines addObject:engine];
    }
    
    // Save the now-filled array into the dictionary that gets saved as a plist
    editedPlist[@"IOKitPersonalities"][@"PhantomAudioDriver"][@"AudioEngines"] = engines;
}


// Gathers all of our interfaces and saves them into their plist
-(void)savePlist
{
    // Generate the editedPlist
    [self makePlist];
    
    // Write plist to temporary file
    NSString *tmpPlistFile = @"/tmp/soundblossomer-output.plist";
    [editedPlist writeToFile:tmpPlistFile atomically:YES];
    
    // Ugly hack: call AppleScript to move the plist to the appropriate directory
    NSString *shellCommand = [[NSString alloc] initWithFormat:@"do shell script \"/bin/cp '%@' '%@'; /usr/sbin/chown root:wheel '%@'; /bin/chmod 644 '%@'\" with administrator privileges", tmpPlistFile, plistPath, plistPath, plistPath];
    
    NSAppleScript *script;
    script = [[NSAppleScript alloc] initWithSource:shellCommand];
    NSDictionary* errDict = NULL;
    [script executeAndReturnError:&errDict];
    
    
    if (errDict)
    {
        // An error occourred (usually the user dismissed the admin password prompt)
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to save interfaces"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"SoundBlossomer was not able to write the plist file to the filesystem."];
        [alert runModal];
    }
    else
    {
        // Everything was Ok
        NSAlert *alert = [NSAlert alertWithMessageText:@"Configuration saved"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"You need to reload Soundflower or reboot your Mac to apply any changes you made."];
        [alert runModal];

    }
}

-(void)savePlistAndReload{
    // Ask for confirmation
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Continue"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Save changes and reload Soundflower?"];
    [alert setInformativeText:@"To apply your changes, Soundflower needs to be reloaded, which means that any input/output through its interfaces will be stopped.\nMake sure any application that needs Soundflower is closed."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if([alert runModal] == NSAlertFirstButtonReturn)
    { 
        // Generate the editedPlist
        [self makePlist];
        
        // Write plist to temporary file
        NSString *tmpPlistFile = @"/tmp/soundblossomer-output.plist";
        [editedPlist writeToFile:tmpPlistFile atomically:YES];
        
        
        // Ugly hack: use AppleScript to run bash script that moves our plist in the correct locations and unloads/reloads Soundflower
        NSString *shellScript =  [[NSBundle mainBundle] pathForResource:@"movePlistAndReloadSoundflower" ofType:@"sh"];
        NSString *shellCommand = [[NSString alloc] initWithFormat:@"do shell script \"/bin/bash '%@' '%@'\" with administrator privileges", shellScript, tmpPlistFile];
        
        NSAppleScript *script;
        script = [[NSAppleScript alloc] initWithSource:shellCommand];
        NSDictionary* errDict = NULL;
        [script executeAndReturnError:&errDict];
        
        
        if (errDict)
        {
            // An error occourred (usually the user dismissed the admin password prompt)
            NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to save interfaces"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"SoundBlossomer was not able to save/apply your changes."];
            [alert runModal];
        }
        else
        {
            // Everything was Ok
            NSAlert *alert = [NSAlert alertWithMessageText:@"Configuration saved and applied"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Soundblossomer successfully applied your changes."];
            [alert runModal];
            
        }
    }
}

@end
