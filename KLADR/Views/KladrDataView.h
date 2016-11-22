//
//  KladrDataViewController.h
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomXibView.h"

#import "../Models/KladrModels.h"

@interface KladrDataView : CustomXibView

@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *abbreviationTextField;
@property (weak) IBOutlet NSTextField *ocatoTextField;
@property (weak) IBOutlet NSTextField *codeTextField;

@property (weak) IBOutlet NSTextField *regionTextField;
@property (weak) IBOutlet NSTextField *districtTextField;
@property (weak) IBOutlet NSTextField *townTextField;
@property (weak) IBOutlet NSTextField *streetTextField;
@property (weak) IBOutlet NSTextField *relevanceTextField;

@property (strong) KladrObject *representedObject;

- (void) printKladrObject:(KladrObject *)kladrObject;

@end
