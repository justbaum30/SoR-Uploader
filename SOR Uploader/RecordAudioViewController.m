//
//  RecordAudioViewController.m
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/24/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import "RecordAudioViewController.h"

@interface RecordAudioViewController ()
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}
@end

@implementation RecordAudioViewController

@synthesize tempPathUrl, recordButton, stopButton, playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize button appearance
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Recorder settings
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initialize recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:tempPathUrl
                                                settings:recordSettings
                                                   error:nil];
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    [audioRecorder prepareToRecord];
}

- (IBAction)recordTapped:(id)sender
{
    // Stop playing before recording
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
    }
    
    // If already recording, pause and update button
    if (audioRecorder.isRecording) {
        [audioRecorder pause];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    // Else record audio
    else {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        
        [audioRecorder record];
        [recordButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender
{
    [audioRecorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)playTapped:(id)sender
{
    if (!audioRecorder.isRecording) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tempPathUrl error:nil];
        audioPlayer.delegate = self;
        [audioPlayer play];
    }
}

- (IBAction)cancelRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - AVAudioRecorderDelegate methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
}


# pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
