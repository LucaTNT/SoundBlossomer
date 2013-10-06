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
    // Call the appropriate function, based on which field was edited
    if ([[tableColumn identifier] isEqualToString:@"interfaceName"]) {
        [manager setInterfaceName:object atIndex:row];
    }
    
    if ([[tableColumn identifier] isEqualToString:@"channelNumber"]) {
        // Prevent channel number < 2
        if ([object integerValue] < 2) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid channel number"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"The minimum number of channels is two."];
            [alert runModal];

        }
        
        // Check if the channel number is odd (not allowed) or even
        else if ([object integerValue] % 2)
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid channel number"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"The number of channels of any interface must be an even number."];
            [alert runModal];
        }
        else
        {
            [manager setChannelNumber:object atIndex:row];
        }
    }

}

// Action connected to the + button
-(IBAction)addInterface:(id)sender
{
    [manager addInterfaceWithName:@"Interface Name" withChannelNumber:@"2"];
    [table reloadData];

}

// Action connected to the - button
-(IBAction)removeInterface:(id)sender{
    // Only delete if a row is selected, then reload the table
    if ([table selectedRow] != -1)
    {
        [manager removeInterfaceAtIndex:[table selectedRow]];
        [table reloadData];
    }
}

// Action connected to the save button
-(IBAction)saveInterfaces:(id)sender
{
    [manager savePlist];
}

// Action connected to the save & reload button
-(IBAction)saveInterfacesAndReloadSoundflower:(id)sender
{
    [manager savePlistAndReload];
}

// Quit when users closes the window
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
