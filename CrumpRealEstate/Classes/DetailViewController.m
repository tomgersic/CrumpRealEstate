//
//  DetailViewController.m
//  CrumpRealEstate
//
//  Created by Tom Gersic on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize theView,nameLabel,detailsLabel,propertyNameLabel,propertyAddressLabel,propertyCityLabel,propertyStateLabel,propertyZipLabel,propertyYearBuiltLabel,propertyDescriptionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Work Harder™";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**
 * Demo 3.2 - Show the labels and hide the lady image (or do the reverse)
 **/
- (void) labelsAreHidden:(BOOL)shouldHideLabels {
    [titleRepairNumberLabel setHidden:shouldHideLabels];
    [titleDetailsLabel setHidden:shouldHideLabels];
    [titlePropertyNameLabel setHidden:shouldHideLabels];
    [titlePropertyAddressLabel setHidden:shouldHideLabels];
    [titlePropertyCityLabel setHidden:shouldHideLabels];
    [titlePropertyStateLabel setHidden:shouldHideLabels];
    [titlePropertyZipLabel setHidden:shouldHideLabels];
    [titlePpropertyYearBuiltLabel setHidden:shouldHideLabels];
    [titlePropertyDescriptionLabel setHidden:shouldHideLabels]; 
    [workHarderLadyImage setHidden:!shouldHideLabels];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/**
 * DEMO 1.2.8 DetailViewContoller implements UISplitViewControllerDelegate interface, and here's what it overrides...
 * In portrait mode, place a "Repairs" button to show the master detail view with the table
 **/
#pragma mark - Split View Controller delegate methods
- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{  
    [barButtonItem setTitle:@"Repairs"];    
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
