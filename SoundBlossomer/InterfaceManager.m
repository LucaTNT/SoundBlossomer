//
//  InterfaceManager.m
//  SoundBlossomer
//
//  Created by Luca Zorzi on 26/12/12.
//  Copyright (c) 2012 Luca Zorzi. All rights reserved.
//

#import "InterfaceManager.h"

@implementation InterfaceManager
@synthesize interfaces;

-(NSArray *)getInterfaces
{
//    Scheda *s1 = [[Scheda alloc] init];
//    Scheda *s2 = [[Scheda alloc] init];
//    
//    s1.nomeScheda = @"Scheda 1";
//    s2.nomeScheda = @"Scheda 2";
//    
//    s1.figli = @[ @"A", @"B", @"C" ];
//    s2.figli = @[ @"1", @"2", @"3" ];
//
//    return @[ s1, s2 ];
    
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/Extensions/Soundflower.kext/Contents/Info.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/Users/luca/Info.plist"];
    NSArray *audioEngines = dict[@"IOKitPersonalities"][@"PhantomAudioDriver"][@"AudioEngines"];
    
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

-(void)setChannelNumber:(id)newChannelNumber atIndex:(NSInteger)row
{
    // For safety's sake, we copy the old values off the array
    NSString *interfaceName = [[interfaces objectAtIndex:row] objectForKey:@"interfaceName"];

    
    [interfaces replaceObjectAtIndex:row withObject:@{@"interfaceName" : interfaceName,
                                                      @"channelNumber" : newChannelNumber}];
}

-(void)setInterfaceName:(id)newInterfaceName atIndex:(NSInteger)row
{
    // For safety's sake, we copy the old values off the array
    NSString *channelNumber = [[interfaces objectAtIndex:row] objectForKey:@"channelNumber"];
    
    
    [interfaces replaceObjectAtIndex:row withObject:@{@"interfaceName" : newInterfaceName,
                                                      @"channelNumber" : channelNumber}];
}

-(NSInteger)countInterfaces
{
    return [[self interfaces] count];
}

-(void)addInterfaceWithName:(NSString *)interfaceName withChannelNumber:(id)channelNumber
{
    [[self interfaces] addObject:@{@"interfaceName" : interfaceName,
                                   @"channelNumber" : channelNumber}];

}

-(void)removeInterfaceAtIndex:(NSInteger)row
{
    [[self interfaces] removeObjectAtIndex:row];
}

-(void)savePlist
{
    NSDictionary *originalPlist = [NSDictionary dictionaryWithContentsOfFile:@"/Users/luca/Info.plist"];
    NSMutableDictionary *plist = originalPlist.mutableCopy;
    //NSArray *audioEngines = dict[@"IOKitPersonalities"][@"PhantomAudioDriver"][@"AudioEngines"];
    
    NSMutableArray *engines = @[].mutableCopy;
    
    NSArray *formats = @[ @{@"IOAudioStreamAlignment" : @"1",
                            @"IOAudioStreamBitDepth" :  @"32",
                            @"IOAudioStreamBitWidth" : @"32",
                            @"IOAudioStreamByteOrder" : @"0",
                            @"IOAudioStreamDriverTag" : @"0",
                            @"IOAudioStreamIsMixable" : @"1",
                            @"IOAudioStreamNumChannels" : @2, // QUESTO DEVE ESSERE UN INTEGER
                            @"IOAudioStreamNumericRepresentation" : @1936289396, // QUESTO DEVE ESSERE UN INTEGER
                            @"IOAudioStreamSampleFormat" : @1819304813 // QUESTO DEVE ESSERE UN INTEGER
                            }
                          ];
    NSArray *sampleRates = @[@44100, @48000, @88200, @96000, @176400, @192000];
    
    for (NSDictionary *currentInterface in [self interfaces])
    {
        NSDictionary *engine = @{@"BlockSize" : @"8192",
                                 @"Description" : [currentInterface objectForKey:@"interfaceName"],
                                 @"Formats" : formats,
                                 @"NumBlocks" : @"2",
                                 @"NumStreams" : @"1",
                                 @"SampleRates" : sampleRates};
        
        [engines addObject:engine];
    }
    
    plist[@"IOKitPersonalities"][@"PhantomAudioDriver"][@"AudioEngines"] = engines;
    
    if (![plist writeToFile:@"/newPlist.plist" atomically:YES])
    {
        NSLog(@"Failed to save");
    }

}

@end
