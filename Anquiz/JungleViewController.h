//
//  JungleViewController.h
//  Anquiz
//
//  Created by Igor de Almeida on 24/04/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JungleViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *option1, *option2, *option3, *option4, *playButton;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel, *timeLapsedLabel;
@property (nonatomic, weak) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;

@end
