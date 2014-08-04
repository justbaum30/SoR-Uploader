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
    if ([[DBSession sharedSession] isLinked]) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    else {
        restClient = nil;
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
    if ([[sender object] boolValue]) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    else {
        restClient = nil;
    }
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set correct source type of image
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    // Show image picker
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get picked image
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85);
    
    // Write to temp folder
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:@"SoR-image"] URLByAppendingPathExtension:@"jpg"];
    [imageData writeToURL:fileURL atomically:YES];
    
    // Upload to dropbox
    [restClient uploadFile:@"SoR-image.jpg"
                    toPath:@"/"
             withParentRev:nil
                  fromPath:fileURL.path];
    
    // Close image picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recordAudio:(id)sender
{
    
}

- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    NSLog(@"File upload failed with error: %@", error);
}

@end
