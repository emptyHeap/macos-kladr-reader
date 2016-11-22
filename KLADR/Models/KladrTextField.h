//
//  KladrTextField.h
//  KLADR
//
//  Created by Konstantin on 21/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../Models/KladrObject.h"

@interface KladrTextField : NSTextField<NSTextFieldDelegate, NSControlTextEditingDelegate>

@property (strong) KladrObject *selectedObject;
//@property IBOutlet KladrTextField *childListReceiver;


@end
