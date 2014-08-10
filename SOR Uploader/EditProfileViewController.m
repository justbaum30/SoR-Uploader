//
//  EditProfileViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/7/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UploadProfile.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

@synthesize profile, nameTextField, receiptPathTextField, mileagePathTextField;

- (id)initWithUploadProfile:(UploadProfile *)aProfile
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
}

- (IBAction)cancelEdit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveEdit:(id)sender
{
    self.profileWasSaved();
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
