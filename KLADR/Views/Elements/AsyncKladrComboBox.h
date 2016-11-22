//
//  AsyncComboBox.h
//  KLADR
//
//  Created by Konstantin on 22/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../../Models/KladrObject.h"

//@protocol AsyncDataReceiver
//
//
//
//@end
//
//@protocol AsyncDataSource
//
//- (void) asyncDataReceiver:(is<AsyncDataReceiver>)dataReceiver;
//
//@end

@interface AsyncKladrComboBox : NSComboBox<NSComboBoxDelegate, NSComboBoxDataSource>

@property void(^parentChangedBlock)(KladrObject *parent);
@property AsyncKladrComboBox *child;

- (void) updateWithData:(NSArray <KladrObject *> *)data;

@end
