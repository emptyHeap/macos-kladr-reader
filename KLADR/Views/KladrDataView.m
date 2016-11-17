//
//  KladrDataViewController.m
//  KLADR
//
//  Created by Konstantin on 15/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "KladrDataView.h"

@interface KladrDataView ()

@end

@implementation KladrDataView {
    KladrObject *_kladrObject;
}

@synthesize representedObject = _kladrObject;

- (void)printKladrObject:(KladrObject *)kladrObject {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _nameTextField.stringValue = kladrObject.name;
        _codeTextField.stringValue = kladrObject.code;
        _abbreviationTextField.stringValue = kladrObject.locationType.fullName;
        _ocatoTextField.stringValue = kladrObject.ocatd;
        
        //optional
        if ([kladrObject isKindOfClass:[Region class]]){
            _regionTextField.integerValue = [(Region *)kladrObject regionCode];
            if ([kladrObject isKindOfClass:[Town class]]){
                _townTextField.integerValue = [(Town *)kladrObject townCode];
                if ([kladrObject isKindOfClass:[Street class]]){
                    _streetTextField.integerValue = [(Street *)kladrObject streetCode];
                }
            }
        }
    }];
}

@end
