//
//  ViewController.h
//  googlePlusTest
//
//  Created by Jiamao Zheng on 7/20/15.
//  Copyright (c) 2015 Emerge Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;

@interface ViewController : UIViewController<GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnected;


- (IBAction)googleLogIn:(id)sender;
- (IBAction)googleSignOut:(id)sender;
- (IBAction)googleDisconnected:(id)sender;

@end

