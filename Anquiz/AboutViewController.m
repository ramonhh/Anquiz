//
//  AboutViewController.m
//  Anquiz
//
//  Created by Igor de Almeida on 24/04/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import "AboutViewController.h"
#import "SoundManager.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Back:(id)sender {
    [[SoundManager sharedManager] playSound:@"Click.wav"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
