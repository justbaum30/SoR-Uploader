//
//  EditProfileViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/7/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UploadProfile.h"
#import "UploadProfileStore.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

@synthesize profile, nameTextField, receiptPathTextField, mileagePathTextField;

- (id)initWithUploadProfile:(UploadProfile *)aProfile
                    AtIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        profile = aProfile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (profile) {
        [nameTextField setText:profile.name];
        [receiptPathTextField setText:profile.receiptPath];
        [mileagePathTextField setText:profile.mileagePath];
    }
    
    UITapGestureRecognizer *gestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (IBAction)cancelEdit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveEdit:(id)sender
{
    NSUInteger index = [[[UploadProfileStore sharedStore] allProfiles] indexOfObject:profile];
    profile.name = [nameTextField text];
    profile.receiptPath = [receiptPathTextField text];
    profile.mileagePath = [mileagePathTextField text];
    
    [[UploadProfileStore sharedStore] updateProfile:profile
                                            atIndex:index];
    
    self.profileWasSaved();
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
