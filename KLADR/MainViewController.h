//
//  MainViewController.h
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Views/KladrDataView.h"
#import "Views/Elements/AsyncKladrComboBox.h"

@interface MainViewController : NSViewController

// text fields implementation
@property (weak) IBOutlet KladrDataView *dataView;


// combo box implementation
@property (weak) IBOutlet AsyncKladrComboBox *districtComboBox;
@property (weak) IBOutlet AsyncKladrComboBox *townComboBox;
@property (weak) IBOutlet AsyncKladrComboBox *streetComboBox;
@property (weak) IBOutlet AsyncKladrComboBox *houseComboBox;

@end
