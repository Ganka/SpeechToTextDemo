//
//  ViewController.m
//  SpeechToTextDemo
//
//  Created by gankac on 24/03/17.
//  Copyright © 2017 gankac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    AVAudioEngine *audioEngine;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
    audioEngine = [[AVAudioEngine alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    _microphoneButton.enabled = false;
    
    speechRecognizer.delegate = self;
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if(status == SFSpeechRecognizerAuthorizationStatusAuthorized){
            dispatch_sync(dispatch_get_main_queue(), ^{
                _microphoneButton.enabled = true;
            });
        }else{
            NSLog(@"Authorization failed");
        }
    }];
    
}

-(void)startRecording{
    
    if(recognitionTask != nil){
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    AVAudioInputNode *inputNode = audioEngine.inputNode;
    
    recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    recognitionRequest.shouldReportPartialResults = true;
    
    recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        BOOL isFinal = false;
        
        if(result != nil){
            
            _textView.text = [result.bestTranscription formattedString];
            isFinal = result.isFinal;
        }else if((error != nil) || isFinal){
            
            [audioEngine stop];
            [inputNode removeTapOnBus:0];
            recognitionRequest = nil;
            recognitionTask = nil;
            _microphoneButton.enabled = true;
            
        }
        
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [audioEngine prepare];
    
    [audioEngine startAndReturnError:nil];
}

-(IBAction)microphoneTapped:(id)sender{
    
    if(audioEngine.isRunning){
        [audioEngine stop];
        [recognitionRequest endAudio];
        _microphoneButton.enabled = YES;
        [_microphoneButton setTitle:@"Start recording" forState:UIControlStateNormal];
    }else{
        [self startRecording];
        [_microphoneButton setTitle:@"Stop recording" forState:UIControlStateNormal];
    }
    
}

-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if(available) {
        _microphoneButton.enabled = true;
    } else {
        _microphoneButton.enabled = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
