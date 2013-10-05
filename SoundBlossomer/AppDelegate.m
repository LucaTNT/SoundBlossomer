//
//  AppDelegate.m
//  SoundBlossomer
//
//  Created by Luca Zorzi on 05/10/13.
//  Copyright (c) 2013 Luca Zorzi. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

// Get all currently defined interfaces from the plist
-(void)awakeFromNib
{
    // Init and call our interface manager
    manager = [[InterfaceManager alloc] init];
    [manager getInterfaces];
}

// Count them
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [manager countInterfaces];
}

// Return the appropriate values
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [[[manager interfaces] objectAtIndex:row] objectForKey:tableColumn.identifier];
}


// Change the values of our array
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    if ([[tableColumn identifier] isEqualToString:@"interfaceName"]) {
        [manager setInterfaceName:object atIndex:row];
    }
    
    if ([[tableColumn identifier] isEqualToString:@"channelNumber"]) {
        [manager setChannelNumber:object atIndex:row];
    }

}


-(IBAction)addInterface:(id)sender
{
    [manager addInterfaceWithName:@"Interface Name" withChannelNumber:@"2"];
    [table reloadData];

}
-(IBAction)removeInterface:(id)sender{
    if ([table selectedRow] != -1)
    {
        [manager removeInterfaceAtIndex:[table selectedRow]];
        [table reloadData];
    }
}

-(IBAction)saveInterfaces:(id)sender
{
    [manager savePlist];
}

@end
