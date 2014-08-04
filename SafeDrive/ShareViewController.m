//
//  ShareViewController.m
//  SafeDrive
//
//  Created by Pratyusha Tiruveedhula on 7/22/14.
//  Copyright (c) 2014 ptiruvee. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "ShareViewController.h"
#import "JSON.h"
#import "PresentStatus.h"

@interface ShareViewController (){
    NSMutableArray *allStatus;
    JSON *obj;
    CLGeocoder *geoCoder;
}
@property (strong, nonatomic) IBOutlet UIButton *UpdateStatusButton;

@property (strong, nonatomic) IBOutlet UIButton *UpdateTrafficButton;

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.message = @"  ";
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (self.view.center.y - (loginView.frame.size.height / 2)));
    [self.view addSubview:loginView];
    obj=[JSON getInstance];
    allStatus = obj.reader.readJSON;
    geoCoder = [[CLGeocoder alloc] init];
    loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"publish_actions"]];
    
    [FBDialogs presentShareDialogWithLink:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          NSLog(@"Error: %@", error.description);
                                      } else {
                                          NSLog(@"Success!");
                                      }
                                  }];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGest)];
    [_swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:_swipeLeft];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGest)];
    [_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:_swipeRight];
}

- (void) viewDidAppear:(BOOL)animated {
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
}

-(void) swipeRightGest {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex - 1];
}

-(void) swipeLeftGest {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    [self.tabBarController setSelectedIndex:selectedIndex + 1];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // If the user is logged in, they can post to Facebook using API calls, so we show the buttons
    [_UpdateStatusButton setHidden:NO];
    [_UpdateTrafficButton setHidden:NO];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // If the user is NOT logged in, they can't post to Facebook using API calls, so we show the buttons
    [_UpdateStatusButton setHidden:YES];
    [_UpdateTrafficButton setHidden:YES];
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)UpdateTrafficStatus:(id)sender {
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[allStatus[counter] getLatitude] longitude:[allStatus[counter] getLongitude]];
    [geoCoder reverseGeocodeLocation: location completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *myPlace = [placemarks lastObject];
        self.message = [NSString stringWithFormat:@"Avoid %@,%@,%@ - there's a lot of traffic here! #traffic",myPlace.subThoroughfare,myPlace.thoroughfare,myPlace.locality];
    }];
    [self StatusUpdateWithAPICalls];
}

- (IBAction)UpdateRoadBlockedStatus:(id)sender{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[allStatus[counter] getLatitude] longitude:[allStatus[counter] getLongitude]];
    [geoCoder reverseGeocodeLocation: location completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *myPlace = [placemarks lastObject];
    self.message = [NSString stringWithFormat:@"Guys stay away from %@,%@,%@-its blocked!! #blockedRoad",myPlace.subThoroughfare,myPlace.thoroughfare,myPlace.locality];
        }];
    [self StatusUpdateWithAPICalls];
}

- (void)StatusUpdateWithAPICalls {
    // We will post on behalf of the user, these are the permissions we need:
    NSArray *permissionsNeeded = @[@"publish_actions"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                                                                            defaultAudience:FBSessionDefaultAudienceFriends
                                                                          completionHandler:^(FBSession *session, NSError *error) {
                                                                              if (!error) {
                                                                                  // Permission granted, we can request the user information
                                                                                  [self makeRequestToUpdateStatus];
                                                                              } else {
                                                                                  // An error occurred, handle the error
                                                                                  // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
                                                                                  NSLog(@"%@", error.description);
                                                                              }
                                                                          }];
                                  } else {
                                      // Permissions are present, we can request the user information
                                      [self makeRequestToUpdateStatus];
                                  }
                                  
                              } else {
                                  // There was an error requesting the permission information
                                  // See our Handling Errors guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"%@", error.description);
                              }
                          }];
}

- (void)makeRequestToUpdateStatus {
    
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    
    [FBRequestConnection startForPostStatusUpdate:_message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (!error) {
                                        // Status update posted successfully to Facebook
                                        NSLog(@"result: %@", result);
                                    } else {
                                        // An error occurred, we need to handle the error
                                        // See: https://developers.facebook.com/docs/ios/errors
                                        NSLog(@"%@", error.description);
                                    }
                                }];
}

@end
