//
//  InterfaceManager.h
//  SoundBlossomer
//
//  Created by Luca Zorzi on 26/12/12.
//  Copyright (c) 2012 Luca Zorzi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InterfaceManager : NSObject
{
    NSString *plistPath;
    NSDictionary *originalPlist;
    NSMutableDictionary *editedPlist;
}

@property (nonatomic, retain) NSMutableArray *interfaces;

-(NSArray *)getInterfaces;
-(void)addInterfaceWithName:(NSString *)interfaceName withChannelNumber:(id)channelNumber;
-(void)removeInterfaceAtIndex:(NSInteger)row;
-(void)setChannelNumber:(id)newChannelNumber atIndex:(NSInteger)row;
-(void)setInterfaceName:(NSString *)newInterfaceName atIndex:(NSInteger)row;
-(NSInteger)countInterfaces;
-(void)savePlist;
-(void)savePlistAndReload;

@end
