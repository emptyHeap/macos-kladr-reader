//
//  MainViewController.m
//  Kladr
//
//  Created by Konstantin on 02/11/16.
//  Copyright © 2016 Konstantin. All rights reserved.
//

#import "MainViewController.h"

#import "Models/KladrModels.h"
#import "AppDelegate.h"
#import "ORM/KladrORM.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    
    KladrIndex *_regions, *_towns, *_streets, *_houses;
    NSArray <LocationType *> *_locations;
    
    KladrObject *_lastChanged;
    Region *_selectedRegion;
    Town *_selectedTown;
    Street *_selectedStreet;
    House *_selectedHouse;
    
    KladrORM *_kladrDatabase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init stuff
    AppDelegate *applicationDelegate = ((AppDelegate *)[[NSApplication sharedApplication] delegate]);
    _kladrDatabase = applicationDelegate.kladrDatabase;
    [_kladrDatabase loadLocationTypesForBlock:^(NSArray<LocationType *> *locations) {
        _locations = locations;
    }];
    
    //configure comboBoxes
    [_kladrDatabase loadRegionsForBlock:^(NSArray<Region *> *regions) {
        [_districtComboBox updateWithData:regions];
    }];
    _districtComboBox.child = _townComboBox;
    
    [_townComboBox setParentChangedBlock:^(KladrObject *region) {
        [_dataView printKladrObject:region];
        [_kladrDatabase loadTownsOfRegion:(Region *)region forBlock:^(NSArray<Town *> *loadedTowns) {
            [_townComboBox updateWithData:loadedTowns];
        }];
    }];
    _townComboBox.child = _streetComboBox;
    
    [_streetComboBox setParentChangedBlock:^(KladrObject *town) {
        [_dataView printKladrObject:town];
        [_kladrDatabase loadStreetsOfTown:(Town *)town forBlock:^(NSArray<Street *> *loadedStreets) {
            [_streetComboBox updateWithData:loadedStreets];
        }];
    }];
    _streetComboBox.child = _houseComboBox;

    [_houseComboBox setParentChangedBlock:^(KladrObject *street) {
        [_dataView printKladrObject:street];
        [_kladrDatabase loadHousesOfStreet:(Street *)street forBlock:^(NSArray<House *> *loadedHouses) {
            [_houseComboBox updateWithData:loadedHouses];
        }];
    }];
    
    _regions = [[KladrIndex alloc] init];
    _towns = [[KladrIndex alloc] init];
    _streets = [[KladrIndex alloc] init];
    _houses = [[KladrIndex alloc] init];
}

@end
