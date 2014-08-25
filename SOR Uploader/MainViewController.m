//
//  MainViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/3/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "MainViewController.h"
#import "RecordAudioViewController.h"
#import "UploadProfile.h"
#import "UploadProfileStore.h"

#define RecordAudioSegue @"RecordAudioSegue"

@interface MainViewController ()
{
    NSArray *profilePickerData;
    UploadProfile *selectedProfile;
    DBRestClient *restClient;
}

@end

@implementation MainViewController

@synthesize profilePicker, addPhotoButton, addMileageButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Watch for dropbox link change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dropboxLinkChanged:)
                                                 name:@"dropboxLinkChanged"
                                               object:nil];
    
    // Setup dropbox
    if ([[DBSession sharedSession] isLinked]) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    else {
        restClient = nil;
        [[DBSession sharedSession] linkFromController:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update enabled values
    [self updateButtons];
    
    // Setup profile picker
    profilePickerData = [[UploadProfileStore sharedStore] allProfiles];
    selectedProfile = [profilePickerData objectAtIndex:[profilePicker selectedRowInComponent:0]];
    [profilePicker reloadAllComponents];
}


# pragma mark - Dropbox status methods

- (void)updateButtons
{
    addPhotoButton.enabled = [[DBSession sharedSession] isLinked];
    addMileageButton.enabled = [[DBSession sharedSession] isLinked];
}

- (void)dropboxLinkChanged:(id)sender
{
    if ([[sender object] boolValue]) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    else {
        restClient = nil;
    }
    
    [self updateButtons];
}


# pragma mark - Upload actions

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
    NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:@"receiptImage"] URLByAppendingPathExtension:@"jpg"];
    [imageData writeToURL:fileURL atomically:YES];
    
    // Upload to dropbox
    [restClient uploadFile:[self createFileName:YES]
                    toPath:selectedProfile.receiptPath
             withParentRev:nil
                  fromPath:fileURL.path];
    
    // Close image picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)recordAudio:(id)sender
{
    [self performSegueWithIdentifier:RecordAudioSegue sender:self];
}

- (NSString *)createFileName:(BOOL)isImage
{
    NSString *profileName = [selectedProfile.name stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@"_"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    if (isImage) {
        return [NSString stringWithFormat:@"%@-%@.jpg", profileName, timestamp];
    }
    else {
        return [NSString stringWithFormat:@"%@-%@.m4a", profileName, timestamp];
    }
}


# pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return profilePickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    UploadProfile *profile = [profilePickerData objectAtIndex:row];
    return profile.name;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    selectedProfile = [profilePickerData objectAtIndex:row];
}


# pragma mark - DBRestClientDelegate

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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:RecordAudioSegue]) {
        // Temporary file location until can upload
        NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
        NSURL *fileURL = [[tmpDirURL URLByAppendingPathComponent:@"mileageAudio"] URLByAppendingPathExtension:@"m4a"];
        
        UINavigationController *navViewCtrl = (UINavigationController *)segue.destinationViewController;
        RecordAudioViewController *recordViewCtrl = (RecordAudioViewController *)navViewCtrl.topViewController;
        
        [recordViewCtrl setTempPathUrl:fileURL];
        
        // Upload on completion
        [recordViewCtrl setRecordingWasSaved: ^() {
            [restClient uploadFile:[self createFileName:NO]
                            toPath:selectedProfile.mileagePath
                     withParentRev:nil
                          fromPath:fileURL.path];
        }];
    }
}

@end
