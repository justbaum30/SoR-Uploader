//
//  RecordAudioViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/24/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "RecordAudioViewController.h"

@interface RecordAudioViewController ()

@end

@implementation RecordAudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
