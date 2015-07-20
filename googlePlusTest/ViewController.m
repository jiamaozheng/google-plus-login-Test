//
//  ViewController.m
//  googlePlusTest
//
//  Created by Jiamao Zheng on 7/20/15.
//  Copyright (c) 2015 Emerge Media. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"

static NSString * const kClientId = @"641220392338-27462i9hgc2r473lul9qvsahc8vs7upm.apps.googleusercontent.com";

@interface ViewController ()

@property (strong, nonatomic) GPPSignIn *signIn;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation ViewController

@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signOutButton.hidden = YES;
    self.signInButton.hidden = NO;

    [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    self.signInButton.backgroundColor = [UIColor greenColor];
    self.signInButton.titleLabel.textColor = [UIColor redColor];
    [self.signInButton addTarget:self action:@selector(signInGoogle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)signInGoogle: (UIButton *) sender {
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.shouldFetchGooglePlusUser = YES;
    self.signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    self.signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    self.signIn.delegate = self;
          [[GPPSignIn sharedInstance] authenticate];
    //
    //     [GPPSignInButton class];
    
    //    [signIn trySilentAuthentication];
}
//
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        self.signOutButton.hidden = NO;
//        [self.signInButton setTitle:@"Sign Out" forState:UIControlStateNormal];
//        self.signInButton.titleLabel.textColor = [UIColor whiteColor];
        
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        self.signOutButton.hidden = YES;
//        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
//        self.signInButton.titleLabel.textColor = [UIColor whiteColor];
        // Perform other actions here
    }
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
        NSLog(@"%@", self.signIn.authentication.userEmail);
        [self retrivevProfileInfo];
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}


// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    
    if (authenticated) {
        [self.signInButton setTitle:@"Sign Out" forState:UIControlStateNormal];
        self.signInButton.titleLabel.textColor = [UIColor whiteColor];
   
    } else {
        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
         self.signInButton.titleLabel.textColor = [UIColor whiteColor];
    }
}


- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}

- (IBAction)googleLogIn:(id)sender {

}

- (IBAction)googleSignOut:(id)sender {
    [self signOut];
//    [self disconnect];
    
    self.signInButton.hidden = NO;
    self.signOutButton.hidden = YES;
}

- (IBAction)googleDisconnected:(id)sender {
}

- (void)retrivevProfileInfo{
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
   
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    // Retrieve the display name and "about me" text
                    NSString *description = [NSString stringWithFormat:
                                             @"%@\n%@", person.displayName,
                                             person.aboutMe];
                     NSLog(@"description:= %@",description);
                     NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                     NSLog(@"GoogleID=%@",person.identifier);
                     NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                     NSLog(@"Gender=%@",person.gender);
                     NSLog(@"birthday=%@",person.birthday);
                     NSLog(@"imageURL=%@",person.image);
                     NSLog(@"JSON=%@",person.JSON);
                     NSLog(@"Language=%@",person.language);
                }
            }];
    
    
}
@end
