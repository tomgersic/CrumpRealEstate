//
//  MasterViewController.h
//  CrumpRealEstate
//
//  Created by Tom Gersic on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "DetailViewController.h"
#import "SFSmartStore.h"
#import "SFSoupIndex.h"

@interface MasterViewController : UITableViewController <SFRestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //DEMO 2.1 Master View Controller - Set up an IBOutlet for the tableView from Interface Builder, and connect it
    IBOutlet UITableView *tableView;
    //Array used to store the records we get back from DBDC or SmartStore
    NSMutableArray *dataRows;
    //Reference to the detail view controller, assigned in AppDelegate
    DetailViewController *detailViewController;
    //Demo 2.1.1 Reference to the SmartStore Store
    SFSmartStore *crumpStore;
    //Demo 2.1.2 - Data structure containing the same data as dataRows Array, 
    // but better structured for UITableView sections in UITableViewDataSource and UITableViewDelegate methods
    NSMutableDictionary *sectionRecords;
    //Demo 2.1.3 - Used by UITableViewDataSource and UITableViewDelegate methods to look up an Id for a given Name
    NSMutableDictionary *idForName;
}
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataRows;
@property (nonatomic,retain) DetailViewController *detailViewController;
@end
