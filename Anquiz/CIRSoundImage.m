//
//  CIRSoundImage.m
//  NanoChallenge01
//
//  Created by Ramon Honorio on 3/24/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import "CIRSoundImage.h"

@interface CIRSoundImage ()

@end

@implementation CIRSoundImage

- (void) loadImages{
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *predicate = [NSString stringWithFormat:@"self BEGINSWITH 'img_%@_'", self.levelPrefix];
    
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:predicate];
    NSArray *onlyPNGs = [dirContents filteredArrayUsingPredicate:fltr];
    
    _images = onlyPNGs;
    NSLog(@"Imagens: %@", _images);
}

- (void) loadSounds {
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *predicate = [NSString stringWithFormat:@"self BEGINSWITH 'som_%@_'", self.levelPrefix];
    
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:predicate];
    NSArray *onlyMP3 = [dirContents filteredArrayUsingPredicate:fltr];
    
    _sounds = onlyMP3;
    NSLog(@"%@", predicate);
    NSLog(@"Sons: %@", _sounds);
}

- (id) init {
    if (self = [super init]) {
        self.levelPrefix = @"farm";
        [self loadImages];
        [self loadSounds];
    }
    return self;
}

- (id) initLevel :(NSString *)level{
    if (self = [super init]){
        self.levelPrefix = level;
        [self loadImages];
        [self loadSounds];
    }
    return self;
}

@end
