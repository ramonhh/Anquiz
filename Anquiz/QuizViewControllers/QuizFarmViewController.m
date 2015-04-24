//
//  CIRSoundTestViewController.m
//  NanoChallenge01
//
//  Created by Ramon Honorio on 3/22/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import "QuizFarmViewController.h"
#import "SoundManager.h"
#import "CIRSoundImage.h"
#import "AudioToolbox/AudioToolbox.h"

@interface QuizFarmViewController ()
{
    NSArray *_buttonArray;
    BOOL inGame;
    
    // Propriedades auxiliares
    NSUInteger answerIndex;
    NSUInteger answerIndexOnArray;
    NSUInteger score, highScore;
    UIImage *answerImage, *imagemPadrao;
    Sound *answerSound;
    NSDate *start;
    NSTimeInterval timeInterval;
    NSTimer *timer;
    int timeLapsed;
}

@property (nonatomic) CIRSoundImage *files;

@end

@implementation QuizFarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Inicializando as referencias de arquivos para a fase
    self.files = [[CIRSoundImage alloc] initLevel:@"farm"];
    
    // Configurando o sharedManager
    [[SoundManager sharedManager] prepareToPlay];
    [[SoundManager sharedManager] setMusicVolume:0.1];
    [[SoundManager sharedManager] setSoundVolume:1];
    [[SoundManager sharedManager] stopAllSounds];
    
    // Array para acessar os 4 botoes
    _buttonArray = @[self.option1, self.option2, self.option3, self.option4];
    
    // Setando os estados 'padrao' para os componentes
    inGame = NO;
    score = 0;
    imagemPadrao = [UIImage imageNamed:@"novacor.png"];
    for (UIButton *button in _buttonArray) {
        [button setImage:imagemPadrao forState:UIControlStateNormal];
    }
    [self.playButton setTitle:@"     Play     " forState:UIControlStateNormal];
    // Labels e botoes com valores padrao
    self.scoreLabel.text = @"";
    self.timeLapsedLabel.text = @"";
    
    // Snippet used to get your highscore from the prefs.
    highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"] integerValue];
    self.highScoreLabel.text = [NSString stringWithFormat:@"Highscore: %@", [NSNumber numberWithInteger:highScore]];
    
    timeLapsed = 5;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [[SoundManager sharedManager] playMusic:@"backgroundMusic.mp3" looping:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playOnTouch:(UIButton *)sender{
    [[SoundManager sharedManager] stopAllSounds];
    if(!inGame){
        [self newGame:sender];
    } else {
        [[SoundManager sharedManager] playSound:answerSound.name];
    }
}



- (void) newGame: (UIButton *)sender {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lu", (unsigned long)score];
    self.timeLapsedLabel.text = [NSString stringWithFormat:@"Time: %lu", (unsigned long)timeLapsed];
    [sender setTitle:@"     Play Sound     " forState:UIControlStateNormal];
    // Comeca o game
    inGame = YES;
    self.gameOverLabel.hidden = YES;
    
    start = [NSDate date];
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(decrementScore)
                                           userInfo:NULL repeats:YES];
    
    for (UIButton *button in _buttonArray)
        [button setAlpha:1];
    
    [self nextLevel];
}

- (void) nextLevel {
    [[SoundManager sharedManager] stopAllSounds];
    
    // Gerando um index aleatorio em busca de uma nova resposta
    answerIndex = arc4random() % [self.files.sounds count];
    
    // Criando um novo som
    answerSound = [[Sound alloc] initWithContentsOfFile:self.files.sounds[answerIndex]];
    
    if(inGame)
        [[SoundManager sharedManager] playSound:answerSound.name];
    
    // Gerando um numero aleatorio (0 ... 3)
    answerIndexOnArray = arc4random() % (4);
    NSUInteger answerOnArrayAux = answerIndexOnArray;
    
    // Criando o array das figuras que ja foram colocadas
    NSMutableArray *imagesAlreadyOnView = [NSMutableArray array];
    [imagesAlreadyOnView addObject:@(answerIndex)];
    
    // Percorre o array de botoes, colocando a resposta e as imagens
    // em posicao randomica
    BOOL answerOnView = NO;
    for (UIButton *button in _buttonArray) {
        if (answerOnArrayAux>0 || answerOnView) {
            NSUInteger novoIndice = arc4random() % [self.files.images count];
            
            while ([imagesAlreadyOnView containsObject:@(novoIndice)]) {
                novoIndice = arc4random() % [self.files.images count];
            }
            [imagesAlreadyOnView addObject:@(novoIndice)];
            
            UIImage *img = [UIImage imageNamed:self.files.images[novoIndice]];
            [button setImage:img forState:UIControlStateNormal];
            answerOnArrayAux--;
        } else {
            answerImage = [UIImage imageNamed:self.files.images[answerIndex]];
            [button setImage:answerImage forState:UIControlStateNormal];
            answerOnView = YES;
        }
    }
}

- (void) gameOver:(UIButton *)sender {
    inGame = NO;
    
    // Animacao de fade na cor do score (Vermelho)
    [self changeScoreColor:[UIColor redColor] :0.25];
    [self performSelector:@selector(redToWhite) withObject:nil afterDelay:1];
    
    // Vibrar
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    // Salva o highScore
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:highScore] forKey:@"HighScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.highScoreLabel.text = [NSString stringWithFormat:@"Highscore: %@", [NSNumber numberWithInteger:highScore]];
    self.highScoreLabel.textColor = [UIColor whiteColor];
    
    // Label do gameover
    self.gameOverLabel.hidden = NO;
    self.gameOverLabel.text = [NSString stringWithFormat:@"Game over! Your score was %lu", (unsigned long)score];
    self.gameOverLabel.textColor = [UIColor redColor];
    [self performSelector:@selector(gameOverTransitionColor) withObject:nil afterDelay:1];
    
    [sender setTitle:@"     Play     " forState:UIControlStateNormal];
    
    [timer invalidate];
    timer = nil;
    
    for (UIButton *button in _buttonArray)
        [button setAlpha:0.5];
    
    // Recarrega o jogo
    [self viewDidLoad];
}

- (IBAction) optionOnTouch:(UIButton*) sender{
    [[SoundManager sharedManager] stopAllSounds];
    if (inGame){
        if ([sender isEqual:_buttonArray[answerIndexOnArray]]) {
            //            NSLog(@"Certo!");
            [self correctAnswer];
            
        } else {
            //            NSLog(@"Errado!");
            [self wrongAnswer];
        }
    }
}

- (void) decrementScore{
    timeLapsed-=1;
    self.timeLapsedLabel.text = [NSString stringWithFormat:@"Time: %d", timeLapsed];
    if (timeLapsed<0) {
        [self gameOver:self.playButton];
        [timer invalidate];
        timer = nil;
    } else if (timeLapsed<=5){
        [self changeTimeColor:[UIColor redColor] :0.2];
    }
}

- (void) correctAnswer {
    // Soma o score
    score+=50;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %zd", score];
    
    // Animacao de fade na cor do score (verde)
    [self changeScoreColor:[UIColor greenColor] :0.25];
    [self performSelector:@selector(greenToWhite) withObject:nil afterDelay:0.5];
    
    // Se o score ultrapassou o highScore
    // Label highScore passa a receber o Score
    if(score>highScore) {
        highScore = score;
        self.highScoreLabel.textColor = [UIColor greenColor];
        [self.highScoreLabel setNeedsDisplay];
        self.highScoreLabel.text = [NSString stringWithFormat:@"Highscore: %@", [NSNumber numberWithInteger:highScore]];
    }
    
    // Carrega o proximo nivel
    [self nextLevel];
}

- (void) wrongAnswer {
    // Soma o score
    if(score>0)
    score-=50;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %zd", score];
    
    // Animacao de fade na cor do score (verde)
    [self changeScoreColor:[UIColor redColor] :0.25];
    [self performSelector:@selector(greenToWhite) withObject:nil afterDelay:0.5];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void) greenToWhite {
    [UIView transitionWithView:self.view duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.scoreLabel setTextColor:[UIColor whiteColor]];
        [self.scoreLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
}

- (void) redToWhite {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.scoreLabel setTextColor:[UIColor whiteColor]];
        [self.scoreLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
}

- (void) changeScoreColor :(UIColor *) textColor :(float) segundos {
    [UIView transitionWithView:self.view duration:segundos options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.scoreLabel setTextColor:textColor];
        [self.scoreLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
}

- (void) changeTimeColor :(UIColor *) textColor :(float) segundos {
    [UIView transitionWithView:self.view duration:segundos options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.timeLapsedLabel setTextColor:textColor];
        [self.timeLapsedLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
    [self performSelector:@selector(restoreTimeColor) withObject:nil afterDelay:0.2];
}

- (void) restoreTimeColor {
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.timeLapsedLabel setTextColor:[UIColor whiteColor]];
        [self.timeLapsedLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
}

- (void) gameOverTransitionColor {
    [UIView transitionWithView:self.view duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.gameOverLabel setTextColor:[UIColor whiteColor]];
        [self.gameOverLabel setShadowColor:[UIColor blackColor]];
    } completion:nil];
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
