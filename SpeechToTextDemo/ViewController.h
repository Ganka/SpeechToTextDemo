//
//  ViewController.h
//  SpeechToTextDemo
//
//  Created by gankac on 24/03/17.
//  Copyright © 2017 gankac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

@interface ViewController : UIViewController <SFSpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;

-(IBAction)microphoneTapped:(id)sender;

@end

