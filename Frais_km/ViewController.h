//
//  ViewController.h
//  Frais_km
//
//  Created by Titouan on 13/04/2016.
//  Copyright © 2016 Titouan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;


@property (strong, nonatomic) IBOutlet UITextField *km;

@property (strong, nonatomic) IBOutlet UIPickerView *typepicker;

@property (strong, nonatomic) IBOutlet UIPickerView *carbupicker;

@property (strong, nonatomic) NSMutableArray *listetype;

@property (strong, nonatomic) NSMutableArray *listecarbu;

@property (strong, nonatomic) IBOutlet UILabel *resultat;

@property (strong, nonatomic) IBOutlet UIButton *boutton;

- (IBAction)Afficher:(id)sender;

@end

