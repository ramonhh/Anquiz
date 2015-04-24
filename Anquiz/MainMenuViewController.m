//
//  MainMenuViewController.m
//  Anquiz
//
//  Created by Ramon Honorio on 4/24/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SoundManager.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void) viewWillAppear:(BOOL)animated {
    [[SoundManager sharedManager] stopAllSounds];
    [[SoundManager sharedManager] stopMusic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Farm:(id)sender {
    [[SoundManager sharedManager] playSound:@"Click.wav"];
}
- (IBAction)Jungle:(id)sender {
    [[SoundManager sharedManager] playSound:@"Click.wav"];
}
- (IBAction)About:(id)sender {
    [[SoundManager sharedManager] playSound:@"Click.wav"];
}


@end

