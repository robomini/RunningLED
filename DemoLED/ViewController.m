//
//  ViewController.m
//  DemoLED
//
//  Created by TienVV on 10/4/15.
//  Copyright (c) 2015 TienVV. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *optionSelector;

@end

@implementation ViewController
{
    float _screenWitdh;
    float _screenHeight;
    
    float _positionX;
    float _positionY;
    
    float _ballRadius;
    int _margin; // Margin of First ball or Last ball to screen
    float _space; // Space beetween two ball center
    int _numberOfBallPerRow;
    
    int _tagStart;
    int _tagEnd;
    

    int _rowCount;
    NSTimer* timerRunLed;
    
    int _count;
    int _delta;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get screen size of device
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWitdh = screenRect.size.width;
    _screenHeight = screenRect.size.height;
    
    // Initiate context variable
    UIImage* ballImage = [UIImage imageNamed:@"led_green"];
    _ballRadius = ballImage.size.width / 2;
    _margin = 40;
    
    _numberOfBallPerRow = 8;
    _space = (_screenWitdh - 2 * _margin) / (_numberOfBallPerRow - 1);
    
    NSLog(@"Number Ball Per Row: %d, Margin: %d, Space: %3.1f", _numberOfBallPerRow, _margin, _space);
    // Draw ball
    [self drawBall];
    // Run LED
    _count = 0;
    timerRunLed = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                           target:self
                                                         selector:@selector(runLedOption01)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [_optionSelector setSelectedSegmentIndex:0];
}

- (void) drawBall {
    // Initiate first position of first row
    _positionX = _margin;
    _positionY = _optionSelector.center.y + _optionSelector.bounds.size.height / 2 + _ballRadius + 20;
    _rowCount = 0;
    // Initiate tag
    _tagStart = 100;
    _tagEnd = _tagStart - 1;
    NSLog(@"BallPerRow: %d, PosX: %3.1f, PosY: %3.1f", _numberOfBallPerRow, _positionX, _positionY);
    // Number of row is decided by screen height
    do {
        _rowCount++;
        // Draw each row
        for (int i = 0; i < _numberOfBallPerRow; i++) {
            _positionX = _margin + i * _space;
            _tagEnd++;
            [self drawGreyBallAtX:_positionX andY:_positionY withTag:_tagEnd];
        }
        _positionY = _positionY + 2 * _ballRadius + 20;
    } while (_positionY < _screenHeight - _ballRadius);
}

- (void) drawGreyBallAtX: (CGFloat) x
                andY: (CGFloat) y
             withTag: (int) tag {
    UIImageView* imgBall = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"led_grey"]];
    imgBall.center = CGPointMake(x, y);
    imgBall.tag = tag;
    
    [self.view addSubview:imgBall];
}

- (void) removeAllBall {
    for (int i = _tagStart; i <= _tagEnd; i++) {
        UIView* view = [self.view viewWithTag:i];
        // Remove view from super view
        [view removeFromSuperview];
    }
}

- (void) runLedOption01 {
    NSLog(@"Run LED option 01");
    // Turn OFF old led
    for (int i = 0; i < _rowCount; i++) {
        [self turnLedOffWithTag:(100 + i * _numberOfBallPerRow + _count)];
    }
    
    if (_count == _numberOfBallPerRow - 1) {
        _count = 0;
    } else {
        _count++;
    }
    
    // Turn ON old led
    for (int i = 0; i < _rowCount; i++) {
        [self turnLedOnWithTag:(100 + i * _numberOfBallPerRow + _count)];
    }
}

- (void) runLedOption02 {
    NSLog(@"Run LED option 02");
    // Turn OFF old led
    for (int i = 0; i < _rowCount; i++) {
        [self turnLedOffWithTag:(100 + i * _numberOfBallPerRow + _count)];
    }
    
    if (_count == _numberOfBallPerRow - 1) {
        _delta = -1;
    } else if (_count == 0) {
        _delta = 1;
    }
    _count = _count + _delta * 1;
    
    // Turn ON old led
    for (int i = 0; i < _rowCount; i++) {
        [self turnLedOnWithTag:(100 + i * _numberOfBallPerRow + _count)];
    }
}

- (void) runLedOption03 {
    NSLog(@"Run LED option 03");
    // Turn OFF old led
    for (int i = 0; i < _rowCount; i++) {
        if (i % 2 == 0) {
            [self turnLedOffWithTag:(100 + i * _numberOfBallPerRow + _count)];
        } else {
            [self turnLedOffWithTag:(100 + i * _numberOfBallPerRow + (_numberOfBallPerRow - _count - 1))];
        }
    }
    
    if (_count == _numberOfBallPerRow - 1) {
        _count = 0;
    } else {
        _count++;
    }
    
    // Turn ON new led
    for (int i = 0; i < _rowCount; i++) {
        if (i % 2 == 0) {
            [self turnLedOnWithTag:(100 + i * _numberOfBallPerRow + _count)];
        } else {
            [self turnLedOnWithTag:(100 + i * _numberOfBallPerRow + (_numberOfBallPerRow - _count - 1))];
        }
    }
}

- (void) runLedOption04 {
    NSLog(@"Run LED option 04");
    if (_count == _tagEnd - 100) {
        _count = 0;
    } else {
        _count++;
    }
    int tag01 = _tagStart + _count;
    int tag02 = _tagEnd - _count;
    [self toggleLedByTag:tag01];
    [self toggleLedByTag:tag02];
}

- (void) toggleLedByTag:(int) tag {
    UIView* ledView = [self.view viewWithTag:tag];
    if (ledView && [ledView isMemberOfClass:[UIImageView class]]) {
        UIImageView* led = (UIImageView*) ledView;
        if ([led.image isEqual:[UIImage imageNamed:@"led_green"]]) {
            led.image = [UIImage imageNamed:@"led_grey"];
        } else {
            led.image = [UIImage imageNamed:@"led_green"];
        }
    }
}

- (void) turnLedOnWithTag: (int) tag {
    UIView* ledView = [self.view viewWithTag:tag];
    if (ledView && [ledView isMemberOfClass:[UIImageView class]]) {
        UIImageView* led = (UIImageView*) ledView;
        led.image = [UIImage imageNamed:@"led_green"];
    }
}

- (void) turnLedOffWithTag: (int) tag {
    UIView* ledView = [self.view viewWithTag:tag];
    if (ledView && [ledView isMemberOfClass:[UIImageView class]]) {
        UIImageView* led = (UIImageView*) ledView;
        led.image = [UIImage imageNamed:@"led_grey"];
    }
}

- (IBAction)onOptionSelectected:(id)sender {
    int index = (int) [_optionSelector selectedSegmentIndex];
    NSLog(@"Selected option index: %d", index);
    // Turn off current timer
    if ([timerRunLed isValid]) {
        [timerRunLed invalidate];
    }
    // Set all led to grey
    for (int i = _tagStart; i <= _tagEnd; i++) {
        [self turnLedOffWithTag:i];
    }
    
    _count = -1;
    if (index == 0) {
        timerRunLed = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                               target:self
                                                             selector:@selector(runLedOption01)
                                                             userInfo:nil
                                                              repeats:YES];
    } else if(index == 1) {
        _delta = 1;
        timerRunLed = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                               target:self
                                                             selector:@selector(runLedOption02)
                                                             userInfo:nil
                                                              repeats:YES];
    } else if (index == 2) {
        timerRunLed = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                               target:self
                                                             selector:@selector(runLedOption03)
                                                             userInfo:nil
                                                              repeats:YES];
    } else if (index == 3) {
        timerRunLed = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                               target:self
                                                             selector:@selector(runLedOption04)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

@end
