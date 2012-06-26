/*
 Copyright (c) 2011, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
/*
 NOTE if you ever need to update these, you can obtain them from your Salesforce org,
 (When you are logged in as an org administrator, go to Setup -> Develop -> Remote Access -> New )
 */

// Fill these in when creating a new Remote Access client on Force.com 
/**
 * Demo 1.3 INITIAL SETUP
 * NOTE: these were populated for you automatically on project creation
 **/
static NSString *const RemoteAccessConsumerKey = @"3MVG9y6x0357HleevuJH_Obl4CsUp_rwrV0YaKSnpgClm4DCcVVJHaNB7FJ8SUeHuX0lgl3THIRZaT5cuyZ2W";
static NSString *const OAuthRedirectURI = @"https://login.salesforce.com/services/oauth2/success";

@implementation AppDelegate

#pragma mark - Remote Access / OAuth configuration


- (NSString*)remoteAccessConsumerKey {
    return RemoteAccessConsumerKey;
}

- (NSString*)oauthRedirectURI {
    return OAuthRedirectURI;
}

- (void) dealloc {
    [splitViewController release];
    [super dealloc];
}

#pragma mark - App lifecycle


//NOTE be sure to call all super methods you override.

/**
 * DEMO 1.2 INITIAL SETUP
 * newRootController entry method for SDK apps... called by setupNewRootViewController
 * set up the splitViewController here
 **/
- (UIViewController*)newRootViewController {
    
    //DEMO 1.2.1 init a UISplitViewController... we are doing an iPad app, after all
    splitViewController = [[UISplitViewController alloc] init];
    
    //DEMO 1.2.2 Init Nibs for Master and Detail View Controller
    masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil]; 
    
    //DEMO 1.2.3 Give the Master View Controller a reference to the Detail View Controller
    masterViewController.detailViewController = detailViewController;
    
    //Set up the navigation controllers for both views
    UINavigationController *rootNav = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    UINavigationController *detailNav = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    
    //Pass the two navigation controllers to the Split View Controller's viewControllers property
    splitViewController.viewControllers = [NSArray arrayWithObjects:rootNav, detailNav, nil];
    
    //Set the detailViewController as the SplitViewController's delegate
    splitViewController.delegate = detailViewController;
    
    //Clean up memory
    [masterViewController release];
    [detailViewController release];
    
    return splitViewController;

}

/**
 * DEMO 1.1 INITIAL SETUP
 * Override the setupNewRootViewController from SFNativeRestAppDelegate because it presents a modal view by default, and
 * we want to use a UISplitViewController (which can't be used in a modal view)
 **/
- (void)setupNewRootViewController
{
    UIViewController *rootVC = [[self newRootViewController] autorelease];
    self.viewController = rootVC;
    self.window.rootViewController = rootVC;
}

@end
