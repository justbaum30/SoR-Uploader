//
//  MainViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/3/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    DBRestClient *restClient;
}

@end

@implementation MainViewController

@synthesize addPhotoButton, addMileageButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Watch for dropbox link change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isDropboxLinked:)
                                                 name:@"isDropboxLinked"
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Link"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(linkDropbox)];
    
    // Setup dropbox
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    [self updateButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateButtons];
}

- (void)updateButtons
{
    BOOL isLinked = [[DBSession sharedSession] isLinked];
    addPhotoButton.enabled = isLinked;
    addMileageButton.enabled = isLinked;
    self.navigationItem.rightBarButtonItem.title = isLinked ? @"Unlink" : @"Link";
}

- (void)linkDropbox {
    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] linkFromController:self];
    }
    else {
        [[DBSession sharedSession] unlinkAll];
        [[[UIAlertView alloc] initWithTitle:@"Account Unlinked!"
                                    message:@"Your dropbox account has been unlinked"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        [self updateButtons];
    }
}

- (void)isDropboxLinked:(id)sender
{
    // Is linked
    if ([[sender object] boolValue]) {
        
    }
    // Not linked
    else {
        
    }
}

@end
