//
//  MainViewController.h
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Views/KladrDataView.h"

@interface MainViewController : NSViewController <NSControlTextEditingDelegate>

@property (weak) IBOutlet NSTextField *districtTextField;
@property (weak) IBOutlet NSTextField *townTextField;
@property (weak) IBOutlet NSTextField *streetTextField;
@property (weak) IBOutlet NSTextField *houseTextField;
@property (weak) IBOutlet KladrDataView *dataView;

@end
