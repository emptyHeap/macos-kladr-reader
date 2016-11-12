//
//  AppDelegate.m
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "AppDelegate.h"
#import "DataHandler.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@end

@implementation AppDelegate{
    KladrORM *_kladrDatabase;
}

@synthesize kladrDatabase = _kladrDatabase;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [DataHandler preload];
    
    _kladrDatabase = [[KladrORM alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"kladr" ofType:@"sqlite"]];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
