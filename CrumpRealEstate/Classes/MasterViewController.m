//
//  MasterViewController.m
//  CrumpRealEstate
//
//  Created by Tom Gersic on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SFSoupQuerySpec.h"
#import "SFSoupCursor.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

@synthesize tableView,dataRows,detailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.dataRows = nil;
    [sectionRecords release];
    [idForName release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sectionRecords = [[NSMutableDictionary alloc] init];
    idForName = [[NSMutableDictionary alloc] init];
    
    self.title = @"Crump Real Estate";
    
    //save to smartStore
    //DEMO 5.1 Use the SFSmartStore singleton to get a shared store named "crumpStore"
    //         - It will be created if it doesn't already exist
    //         - This is the actual sqlite database file being created behind the scenes
    crumpStore = [SFSmartStore sharedStoreWithName:@"crumpStore"];
    
    //register the Repair soup
    //DEMO 5.2 Check to see if the "Repair" soup (table) already exists. If it doesn't, register it
    if(![crumpStore soupExists:@"Repair"])
    {
        //define some indexes
        //DEMO 5.3 - We're going to set up indexes on Id and Name. That way we can query, upsert, and sort on those fields.
        NSDictionary *soupIndexId = [NSDictionary dictionaryWithObjectsAndKeys:@"Id",@"path",kSoupIndexTypeString,@"type", nil];
        NSDictionary *soupIndexName = [NSDictionary dictionaryWithObjectsAndKeys:@"Name",@"path",kSoupIndexTypeString,@"type", nil];
        
        //yeah, I know, "indices"... meh.
        NSArray *soupIndexes = [NSArray arrayWithObjects:soupIndexId,soupIndexName, nil];
        
        //DEMO 5.4 - Actually register the "Repair" soup using the indexes we just defined
        if(![crumpStore registerSoup:@"Repair" withIndexSpecs:soupIndexes]){
            NSLog(@"ERROR: Soup not registered");
        }
    }
    
    //DEMO 4.1 -- Determine if the app is online or offline. If ISONLINE, query Database.com. If !ISONLINE, query SmartStore
    if(ISONLINE) {   
        NSLog(@"APP IS ONLINE, QUERYING DBDC");
        //DEMO 4.2 -- Use the SFRestRequest singleton to query the Database.com REST API
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Details__c,Id,Name,Property__c,Property__r.Name,Property__r.Address__c,Property__r.City__c,Property__r.State__c,Property__r.Zip_Code__c,Property__r.Year_Built__c,Property__r.Property_Description__c FROM Repair__c ORDER BY Name"];    
        //DEMO 4.3 -- Specify this class is the delegate for this request
        //  -- Basically means that this class implements the SFRestDelegate interface, and those delegate
        //     methods will be called once the request comes back.
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
    else {
        NSLog(@"APP IS OFFLINE, QUERYING SMARTSTORE");        
        //create a Query Spec
        //DEMO 6.1 -- Create the Query Spec
        NSDictionary *querySpecDictionary = [NSDictionary dictionaryWithObjectsAndKeys:kQuerySpecTypeRange, kQuerySpecParamQueryType, 
                                                                                        @"Name", kQuerySpecParamIndexPath, 
                                                                                        kQuerySpecSortOrderAscending, kQuerySpecParamOrder, 
                                                                                        @"2000", kQuerySpecParamPageSize, 
                                                                                        nil];    
        //DEMO 6.2 -- Query the "Repair" soup using the query spec
        //         -- Query returns a Cursor that can be used for paging ("x" records at a time)
        SFSoupCursor *queryCursor = [crumpStore querySoup:@"Repair" withQuerySpec:querySpecDictionary];
        //DEMO 6.3 -- Call the same loadTableViewWithRecords that we used for the REST API response
        //         -- We are getting the exact same data structure back from SmartStore that we got from REST API
        [self loadTableViewWithRecords:[queryCursor currentPageOrderedEntries]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/**
 * Load the records into the Table View
 **/
- (void)loadTableViewWithRecords:(NSArray *)records {
    //load data into table
    //DEMO 4.7 -- Keep the records around in the dataRows array
    self.dataRows = [[NSMutableArray alloc] initWithArray:records];
    NSLog(@"data rows count: %d",[self.dataRows count]);
    //DEMO 4.8 -- Call the method to create the sectionRecords data structure for the UITableView
    [self buildRowsForTableFromRecords:records];    
    //DEMO 4.9 -- Reload the table
    [self.tableView reloadData];
}

/**
 * Build data structure for the TableView
 **/
//DEMO 4.10 -- basically just make it easier to access the records via their respective section headers in the table
- (void)buildRowsForTableFromRecords:(NSArray *)records {
    //calculate sections
    for (NSDictionary *row in records) {
        //if this key doesn't already exist
        if(![sectionRecords objectForKey:[row objectForKey:@"Property__c"]]) {
            //create a new array
            NSMutableArray *propertyArray = [NSMutableArray arrayWithObject:row];
            [sectionRecords setObject:propertyArray forKey:[row objectForKey:@"Property__c"]];
            [idForName setObject:[row objectForKey:@"Property__c"] forKey:[[row objectForKey:@"Property__r"] objectForKey:@"Name"]];
        }
        else {
            //get the existing array
            NSMutableArray *propertyArray = [sectionRecords objectForKey:[row objectForKey:@"Property__c"]];
            [propertyArray addObject:row];
            [sectionRecords setObject:propertyArray forKey:[row objectForKey:@"Property__c"]];
        }
    }
}

/**
 * Get the dictionary for the given index path from a tableView
 **/
- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSString *headerId = [idForName valueForKey:sectionTitle];
    return [[sectionRecords valueForKey:headerId] objectAtIndex:indexPath.row];    
}


#pragma mark - SFRestAPIDelegate

/**
 * Response to SFRestRequest
 **/
//DEMO 4.4 -- Handle a successful response from the REST API
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    //DEMO 4.5 -- take the JSON-based response and assign the value specified by the "records" key to the records NSArray.
    NSArray *records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %d", records.count);
  
    //upsert records to the soup
    NSError* error = nil;
    
    //DEMO 5.5 Upsert the records returned from Database.com into the "Repair" smartstore using the "Id" column to key on for upserts.
    [crumpStore upsertEntries:records toSoup:@"Repair" withExternalIdPath:@"Id" error:&error];
    
    //DEMO 5.6 Handle any errors returned from SmartStore
    if(error!=nil){
        NSLog(@"%@", [error localizedDescription]);            
    }
    
    //DEMO 4.6 -- Call method to load the UITableView with these records
    [self loadTableViewWithRecords:records];
}

/**
 * SFRestRequest error handler
 **/
- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

/**
 * SFRestRequest cancelled
 **/
- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

/**
 * SFRestRequest timed out
 **/
- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionRecords count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //DEMO 4.11 -- Set the header for the table section using the sectionRecords structure we built
    NSString *sectionId = [[sectionRecords allKeys] objectAtIndex:section];
    return [[[[sectionRecords objectForKey:sectionId] objectAtIndex:0] objectForKey:@"Property__r"] objectForKey:@"Name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionId = [[sectionRecords allKeys] objectAtIndex:section];
    return [[sectionRecords objectForKey:sectionId] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
	//if you want to add an image to your cell, here's how
	UIImage *image = [UIImage imageNamed:@"icon.png"];
	cell.imageView.image = image;
    
	// Configure the cell to show the data.
    // DEMO 4.12 -- Set the table cell text value using the Name of the Repair
    cell.textLabel.text = [[self dictionaryForIndexPath:indexPath] valueForKey:@"Name"];
    
	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[NSString stringWithFormat:@"Cell %ld in Section %ld is selected", (long)indexPath.row, (long)indexPath.section]); 
    
    //DEMO 4.13 -- Get the NSDictionary containing all of the data for the cell that was selected
    NSDictionary *obj = [self dictionaryForIndexPath:indexPath];
    
    //DEMO 4.14 -- Set all of the labels in the detailView using the selected record
    self.detailViewController.nameLabel.text = [obj objectForKey:@"Name"];
    self.detailViewController.detailsLabel.text = [obj objectForKey:@"Details__c"];
    //make sure the Property__r sub-object exists before trying to reference it
    if([[obj objectForKey:@"Property__r"] isKindOfClass:[NSDictionary class]] > 0)
    {
        self.detailViewController.propertyNameLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"Name"];
        self.detailViewController.propertyAddressLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"Address__c"];
        self.detailViewController.propertyCityLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"City__c"];
        self.detailViewController.propertyStateLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"State__c"];
        self.detailViewController.propertyZipLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"Zip_Code__c"];
        self.detailViewController.propertyYearBuiltLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"Year_Built__c"];
        self.detailViewController.propertyDescriptionLabel.text = [[obj objectForKey:@"Property__r"] objectForKey:@"Property_Description__c"];
    }
    //DEMO 4.15 -- Show the labels (and hide the lady) if they aren't already
    [self.detailViewController labelsAreHidden:NO];
}

@end
