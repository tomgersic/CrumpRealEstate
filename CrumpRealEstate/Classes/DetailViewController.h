//
//  DetailViewController.h
//  CrumpRealEstate
//
//  Created by Tom Gersic on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * DEMO 1.2.7 DetailViewContoller implements UISplitViewControllerDelegate interface
 **/
@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    //Demo 3.1 - Buncha lables and a funny image with IBOutlets for Interface Builder
    IBOutlet UIView *theView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *detailsLabel;
    IBOutlet UILabel *propertyNameLabel;
    IBOutlet UILabel *propertyAddressLabel;
    IBOutlet UILabel *propertyCityLabel;
    IBOutlet UILabel *propertyStateLabel;
    IBOutlet UILabel *propertyZipLabel;
    IBOutlet UILabel *propertyYearBuiltLabel;
    IBOutlet UILabel *propertyDescriptionLabel;

    IBOutlet UILabel *titleRepairNumberLabel;
    IBOutlet UILabel *titleDetailsLabel;
    IBOutlet UILabel *titlePropertyNameLabel;
    IBOutlet UILabel *titlePropertyAddressLabel;
    IBOutlet UILabel *titlePropertyCityLabel;
    IBOutlet UILabel *titlePropertyStateLabel;
    IBOutlet UILabel *titlePropertyZipLabel;
    IBOutlet UILabel *titlePpropertyYearBuiltLabel;
    IBOutlet UILabel *titlePropertyDescriptionLabel;    
    IBOutlet UIImageView *workHarderLadyImage;
}
@property (nonatomic,retain) UIView *theView;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *detailsLabel;
@property (nonatomic,retain) UILabel *propertyNameLabel;
@property (nonatomic,retain) UILabel *propertyAddressLabel;
@property (nonatomic,retain) UILabel *propertyCityLabel;
@property (nonatomic,retain) UILabel *propertyStateLabel;
@property (nonatomic,retain) UILabel *propertyZipLabel;
@property (nonatomic,retain) UILabel *propertyYearBuiltLabel;
@property (nonatomic,retain) UILabel *propertyDescriptionLabel;

- (void) labelsAreHidden:(BOOL)shouldHideLabels;

@end
