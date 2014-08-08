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

- (id)initWithUploadProfile:(UploadProfile *)profile;

@end