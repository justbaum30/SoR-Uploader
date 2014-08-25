//
//  RecordAudioViewController.h
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/24/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordAudioViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property NSURL *tempPathUrl;
@property (weak, nonatomic) IBOutlet UIButton *recordStopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, copy) void (^recordingWasSaved)();

- (IBAction)toggleRecording:(id)sender;
- (IBAction)playRecording:(id)sender;
- (IBAction)cancelRecord:(id)sender;
- (IBAction)uploadRecord:(id)sender;

@end
