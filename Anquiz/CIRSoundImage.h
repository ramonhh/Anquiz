//
//  CIRSoundImage.h
//  NanoChallenge01
//
//  Created by Ramon Honorio on 3/24/15.
//  Copyright (c) 2015 CIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIRSoundImage : NSObject

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *sounds;
@property (nonatomic, copy) NSString *levelPrefix;

- (void) loadImages;
- (void) loadSounds;

- (id) initLevel :(NSString *)level;

@end