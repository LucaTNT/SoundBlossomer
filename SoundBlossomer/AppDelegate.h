//
//  AppDelegate.h
//  SoundBlossomer
//
//  Created by Luca Zorzi on 05/10/13.
//  Licensed under the BSD License
//  Copyright (c) 2013 Luca Zorzi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "InterfaceManager.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView *table;
    InterfaceManager *manager;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)addInterface:(id)sender;
-(IBAction)removeInterface:(id)sender;
-(IBAction)saveInterfaces:(id)sender;
-(IBAction)saveInterfacesAndReloadSoundflower:(id)sender;

@end
