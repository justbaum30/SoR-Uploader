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

@synthesize tempPathUrl, recordStopButton, playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize button appearance
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

- (IBAction)cancelRecord:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadRecord:(id)sender
{
    self.recordingWasSaved();
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - AVAudio actions

- (IBAction)toggleRecording:(id)sender
{
    // Stop playing before recording
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
    }
    
    // If already recording, stop and update button
    if (audioRecorder.isRecording) {
        [audioRecorder stop];
        [recordStopButton setTitle:@"Record" forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
    // Otherwise record audio
    else {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        
        [audioRecorder record];
        [recordStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    
    [playButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction)playRecording:(id)sender
{
    if (!audioRecorder.isRecording) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tempPathUrl error:nil];
        audioPlayer.delegate = self;
        [audioPlayer play];
        
        [playButton setEnabled:NO];
    }
}


# pragma mark - AVAudioRecorderDelegate methods

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [recordStopButton setTitle:@"Record" forState:UIControlStateNormal];
    [playButton setEnabled:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


# pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [playButton setEnabled:YES];
}

@end
