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

static NSString * const kClientId = @"641220392338-27462i9hgc2r473lul9qvsahc8vs7upm.apps.googleusercontent.com";

@interface ViewController ()

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
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
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
@end
