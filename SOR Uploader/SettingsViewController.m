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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        UploadProfile *profile = [[[UploadProfileStore sharedStore] allProfiles] objectAtIndex:indexPath.row];
        [[cell textLabel] setText:profile.name];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [[cell textLabel] setText:@"Link Account"];
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
        [self performSegueWithIdentifier:@"Test" sender:self];
    }
    else {
        
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
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.navigationItem.rightBarButtonItem = addButton;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    else {
        return NO;
    }
}

// Override to support editing the table view.
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Test"]) {
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        UploadProfile *profile = [[[UploadProfileStore sharedStore] allProfiles] objectAtIndex:selectedRow];
        
        UINavigationController *navViewCtrl = (UINavigationController *)segue.destinationViewController;
        EditProfileViewController *editViewCtrl = (EditProfileViewController *)navViewCtrl.topViewController;
        
        [editViewCtrl setProfile:profile];
        [editViewCtrl setProfileWasSaved: ^() {
            NSLog(@"Reload data now.");
        }];
    }
}

@end
