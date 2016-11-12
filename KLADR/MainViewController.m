//
//  MainViewController.m
//  KLADR
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "MainViewController.h"
#import "KLADRModels.h"
#import "DataHandler.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSArray<NSString *> *)control:(NSControl *)control textView:(NSTextView *)textView completions:(NSArray<NSString *> *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index{

    
    if ([[DataHandler dbOperationsQueue] operationCount] > 0){
        [[DataHandler dbOperationsQueue] addOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[control currentEditor] complete:control];
            }];
        }];
        return nil;
    } else {
        NSArray<KLADRObject *> *variants;
        NSString *query = [textView string];
        NSMutableArray <NSString *> *stringResult = [[NSMutableArray alloc] init];
        
        if (control == self.districtTextField)
            variants = [Region searchWithName:query];
        else if (control == self.townTextField)
            variants = [Town searchWithName:query];
        else if (control == self.streetTextField)
            variants = [Street searchWithName:query];
        else if (control == self.houseTextField)
            variants = [House searchWithName:query];
        for (KLADRObject *variant in variants) {
            [stringResult addObject:variant.name];
        }
        
        return stringResult;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj{

    NSString *query = [obj.object stringValue];
    if (query != nil && ![query isEqualToString:@""]){
    
        NSTextField *control = obj.object;
        if (control == self.districtTextField){
            [DataHandler loadTownsForRegion:[Region withName:query]];
        } else if (control == self.townTextField) {
            [DataHandler loadStreetsForTown:[Town withName:query]];
        } else if (control == self.streetTextField) {
            [DataHandler loadHousesForStreet:[Street withName:query]];
        } else if (control == self.houseTextField) {
            // for what all that mess?
        }
    }
    
}

@end
