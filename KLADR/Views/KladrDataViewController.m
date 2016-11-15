//
//  KladrDataViewController.m
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrDataViewController.h"

@interface KladrDataViewController ()

@end

@implementation KladrDataViewController {
    KladrObject *_kladrObject;
}

@synthesize representedObject = _kladrObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do view setup here.
}

- (void)printKladrObject:(KladrObject *)printedObject {
    self.nameTextField.stringValue = printedObject.name;
    self.codeTextField.stringValue = printedObject.code;
}

@end
