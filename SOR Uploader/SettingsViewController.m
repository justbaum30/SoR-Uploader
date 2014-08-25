//
//  SettingsViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/4/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "SettingsViewController.h"
#import "UploadProfile.h"
#import "UploadProfileStore.h"
#import "EditProfileViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#define EditProfileSegue @"EditProfileSegue"

@interface SettingsViewController ()
{
    
}
@end

@implementation SettingsViewController

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Watch for dropbox link change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dropboxLinkChanged:)
                                                 name:@"dropboxLinkChanged"
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - NSNotification

- (void)dropboxLinkChanged:(id)sender
{
    [self.tableView reloadData];
}


#pragma mark - TableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UploadProfileStore sharedStore] allProfiles].count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewBasicCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        UploadProfile *profile = [[[UploadProfileStore sharedStore] allProfiles] objectAtIndex:indexPath.row];
        [[cell textLabel] setText:profile.name];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        // Conditionally set cell text
        if ([[DBSession sharedSession] isLinked]) {
            [[cell textLabel] setText:@"Unlink Account"];
        }
        else {
            [[cell textLabel] setText:@"Link Account"];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Upload Profiles";
    }
    else {
        return @"Account Settings";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:EditProfileSegue sender:self];
    }
    else {
        if ([[DBSession sharedSession] isLinked]) {
            // Unlink account
            [[DBSession sharedSession] unlinkAll];
            [[[UIAlertView alloc] initWithTitle:@"Account Unlinked!"
                                        message:@"Your dropbox account has been unlinked"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            [self.tableView reloadData];
        }
        else {
            // Link account
            [[DBSession sharedSession] linkFromController:self];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        UIBarButtonItem *addButton =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                          target:self
                                                          action:@selector(addProfile:)];
        
        self.navigationItem.leftBarButtonItem = addButton;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Delete logic
    [[UploadProfileStore sharedStore] removeProfileAtIndex:indexPath.row];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

- (void)addProfile:(id)sender
{
    UploadProfile *newProfile = [[UploadProfile alloc] initWithName:@"New Profile"
                                                        ReceiptPath:@"/"
                                                        MileagePath:@"/"];
    [[UploadProfileStore sharedStore] addProfile:newProfile];
    
    NSUInteger newRow = [[UploadProfileStore sharedStore] allProfiles].count - 1;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:EditProfileSegue]) {
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        UploadProfile *profile = [[[UploadProfileStore sharedStore] allProfiles] objectAtIndex:selectedRow];
        
        UINavigationController *navViewCtrl = (UINavigationController *)segue.destinationViewController;
        EditProfileViewController *editViewCtrl = (EditProfileViewController *)navViewCtrl.topViewController;
        
        [editViewCtrl setProfile:profile];
        [editViewCtrl setProfileWasSaved: ^() {
            [self.tableView reloadData];
        }];
    }
}

@end
