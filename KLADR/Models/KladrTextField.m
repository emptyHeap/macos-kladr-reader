//
//  KladrTextField.m
//  KLADR
//
//  Created by Konstantin on 21/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrTextField.h"

@implementation KladrTextField {
    KladrObject *_selectedObject;
}

@synthesize selectedObject = _selectedObject;
//@synthesize childListReceiver;

- (void) setSelectedObject:(KladrObject *)selectedObject {
    self.stringValue = selectedObject.fullName;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
