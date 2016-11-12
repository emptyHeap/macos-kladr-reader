//
//  AppDelegate.h
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ORM/KladrORM.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, readonly) KladrORM* kladrDatabase;

@end

