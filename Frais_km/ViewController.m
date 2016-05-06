//
//  ViewController.m
//  Frais_km
//
//  Created by Titouan on 13/04/2016.
//  Copyright © 2016 Titouan. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typepicker.delegate=self;
    self.typepicker.dataSource=self;
    
    self.carbupicker.delegate=self;
    self.carbupicker.dataSource=self;
    
    _resultat.layer.borderColor=[[UIColor blackColor]CGColor];
    _resultat.layer.borderWidth= 1.0f;
    
    _boutton.layer.cornerRadius = 3;
    
    
    
//---------------------------CREATION DE LA BDD--------------------------------
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"frais.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {

        
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS PUISSANCE (ID INTEGER PRIMARY KEY AUTOINCREMENT, LIBELLE TEXT);";
            
            const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS CARBURANT (ID INTEGER PRIMARY KEY AUTOINCREMENT, CARBU TEXT);";
            
            const char *sql_stmt3 = "CREATE TABLE IF NOT EXISTS TARIFS (IDPUISSANCE INT, IDCARBURANT INT, PRIX FLOAT,FOREIGN KEY (IDPUISSANCE) REFERENCES PUISSANCE(ID),FOREIGN KEY (IDCARBURANT) REFERENCES CARBURANT(ID));";
            
            NSLog(@"done");
            
            if (sqlite3_exec(_DB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Puissance'");
            }
            if (sqlite3_exec(_DB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Carburant'");
            }
            if (sqlite3_exec(_DB, sql_stmt3, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Erreur lors création de la table 'Tarifs'");
            }
            sqlite3_close(_DB);
        }
        
        else {
            NSLog(@"Failed to open/create database");
        }

        
//---------------------------CREATION DE LA BDD--------------------------------
        
        
    
//---------------------------INSERTION DE DONNEES--------------------------------
        
        sqlite3_stmt    *statement;
        
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
            
            NSString *insertpui = [NSString stringWithFormat:@"INSERT INTO PUISSANCE (LIBELLE) VALUES (\"4CV\"),(\"6CV\")"];
            const char *pui_stmt = [insertpui UTF8String];
            
            NSString *insertcarbu = [NSString stringWithFormat:@"INSERT INTO CARBURANT (CARBU) VALUES (\"Diesel\"),(\"Essence\")"];
            const char *carbu_stmt = [insertcarbu UTF8String];
            
            NSString *inserttarif = [NSString stringWithFormat:@"INSERT INTO TARIFS (IDPUISSANCE, IDCARBURANT, PRIX) VALUES (1, 1, 0.52),(2, 1, 0.58),(1, 2, 0.62),(2, 2, 0.67)"];
            const char *tarif_stmt = [inserttarif UTF8String];

            
            sqlite3_prepare_v2(_DB, pui_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"added");
            }
            
            sqlite3_prepare_v2(_DB, carbu_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"added");
            }
            
            sqlite3_prepare_v2(_DB, tarif_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"added");
            }
            
            
            
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }

    
//---------------------------INSERTION DE DONNEES--------------------------------
    
//---------------------INSERTION DES VALEURS DANS UN TABLEAU---------------------
    

        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
        {
        
            sqlite3_stmt    *statement;
            _listetype = [[NSMutableArray alloc] init];
            _listecarbu = [[NSMutableArray alloc] init];
    
            NSString *insertpui = [NSString stringWithFormat:@"SELECT LIBELLE FROM PUISSANCE"];
            NSString *insertcarb = [NSString stringWithFormat:@"SELECT CARBU FROM CARBURANT"];
            
            const char *query_pui = [insertpui UTF8String];
            const char *query_carb = [insertcarb UTF8String];
            
            sqlite3_prepare_v2(_DB, query_pui,-1, &statement, NULL);

    
            if (sqlite3_prepare_v2( _DB, query_pui, -1, &statement, nil) == SQLITE_OK) {
        

                while (sqlite3_step(statement) == SQLITE_ROW) {
            
                    [_listetype addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];

                }
            }
            sqlite3_finalize(statement);
            
            
            sqlite3_prepare_v2(_DB, query_carb,-1, &statement, NULL);
            
            if (sqlite3_prepare_v2( _DB, query_carb, -1, &statement, nil) == SQLITE_OK) {
               
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    [_listecarbu addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                    
                    NSLog(@"%@",_listecarbu);
                    

                    
                }
            }
   
        }
        sqlite3_close(_DB);
    
    //---------------------INSERTION DES VALEURS DANS UN TABLEAU---------------------
    
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    if([thePickerView isEqual: _typepicker]){
        return 1;
    }
    else{
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if([thePickerView isEqual: _typepicker]){
        return [_listetype count];
    }
    else{
        return [_listecarbu count];
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([thePickerView isEqual: _typepicker]){
        return [_listetype objectAtIndex:row];
    }
    else{
        return [_listecarbu objectAtIndex:row];
    }

}

// Picker Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
}


- (IBAction)Afficher:(id)sender {

    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT PRIX FROM TARIFS T INNER JOIN PUISSANCE P ON T.IDPUISSANCE = P.ID INNER JOIN CARBURANT C ON T.IDCARBURANT = C.ID WHERE C.ID=(SELECT ID FROM CARBURANT WHERE CARBU='%@') AND P.ID=(SELECT ID FROM PUISSANCE WHERE LIBELLE='%@')",[self.listecarbu objectAtIndex:[self.carbupicker selectedRowInComponent:0]], [self.listetype objectAtIndex:[self.typepicker selectedRowInComponent:0]]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        sqlite3_prepare_v2(_DB, query_stmt,-1, &statement, NULL);
        
        if (sqlite3_prepare_v2(_DB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *lib = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                float number = [lib floatValue];
                float kilometres = [_km.text floatValue];
                //float result = number*kilometres;
                
                _resultat.text = [NSString stringWithFormat:@"%.2f",number*kilometres];

                NSLog(@"Match found");
            }
            else {
                NSLog(@"Match not found");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_DB);
    }
}



@end
