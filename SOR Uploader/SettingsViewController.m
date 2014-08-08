//
//  SettingsViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/4/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "SettingsViewController.h"
#import "UploadProfile.h"
#import "EditProfileViewController.h"

NSString * const UploadProfilesKey = @"UploadProfiles";

@interface SettingsViewController ()
{
    NSMutableArray *uploadProfiles;
}
@end

@implementation SettingsViewController


+ (void)initialize
{
    UploadProfile *profile1 = [[UploadProfile alloc] initWithName:@"Sons of Realty"
                                                     ReceiptPath:@"/SoR-Receipt/"
                                                     MileagePath:@"/SoR-Mileage/"];
    
    UploadProfile *profile2 = [[UploadProfile alloc] initWithName:@"Brecken Construction"
                                                      ReceiptPath:@"/Brecken-Receipt/"
                                                      MileagePath:@"/Brecken-Mileage/"];
    
    NSArray *profiles = [[NSArray alloc] initWithObjects:profile1, profile2, nil];
    NSData *encodedProfiles = [NSKeyedArchiver archivedDataWithRootObject:profiles];
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:encodedProfiles forKey:UploadProfilesKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        NSData *encodedProfiles = [[NSUserDefaults standardUserDefaults] objectForKey:UploadProfilesKey];
        uploadProfiles = [NSKeyedUnarchiver unarchiveObjectWithData:encodedProfiles];
        uploadProfiles = uploadProfiles.mutableCopy;
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
        return uploadProfiles.count;
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
        UploadProfile *profile = [uploadProfiles objectAtIndex:indexPath.row];
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
                                                          action:@selector(addItem:)];
        
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [uploadProfiles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        UploadProfile *newProfile = [[UploadProfile alloc] initWithName:@"New Profile"
                                                            ReceiptPath:@"/"
                                                            MileagePath:@"/"];
        [uploadProfiles addObject:newProfile];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:1];
        [tableView insertRowsAtIndexPaths:@[newIndexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Test"]) {
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        UploadProfile *profile = [uploadProfiles objectAtIndex:selectedRow];
        
        EditProfileViewController *editProfile = (EditProfileViewController *)segue.destinationViewController;
        [editProfile setProfile:profile];
    }
}

@end
