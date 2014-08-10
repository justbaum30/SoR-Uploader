//
//  EditProfileViewController.h
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/7/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadProfile;

@interface EditProfileViewController : UITableViewController

@property (weak) UploadProfile *profile;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiptPathTextField;
@property (weak, nonatomic) IBOutlet UITextField *mileagePathTextField;

@property (nonatomic, copy) void (^profileWasSaved)();

- (id)initWithUploadProfile:(UploadProfile *)profile;
- (IBAction)cancelEdit:(id)sender;
- (IBAction)saveEdit:(id)sender;

@end
