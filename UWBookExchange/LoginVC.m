//
//  LoginVC.m
//  UWBookExchange
//
//  Created by Li Yansong on 13-11-3.
//  Copyright (c) 2013年 Liyansong. All rights reserved.
//

#import "LoginVC.h"
#import "PhotoWallVC.h"

@interface LoginVC ()<commsDelegate>

@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation LoginVC


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
	// Do any additional setup after loading the view.
    UIButton *loginBtn =[[UIButton alloc] initWithFrame:CGRectMake((320-202)/2, 290, 202, 44)];
    [loginBtn setBackgroundImage:[Utilities imageWithContentsOfFile:@"FBLogin"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 200, 60, 60)];
    [self.view addSubview:self.activityView];
    [PFUser logOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginBtnTapped{
    [[DataStore sharedInstance] reset];
    [self.loginBtn setEnabled:NO];
    [self.activityView startAnimating];
    
    [comms login:self];
}

#pragma mark - commsdelegate
-(void) commsDidLogin:(BOOL)loggedIn{
    [self.loginBtn setEnabled:YES];
    [self.activityView stopAnimating];
    
    if (loggedIn) {
        PhotoWallVC *vc =[[PhotoWallVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please Loggin Again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

@end
