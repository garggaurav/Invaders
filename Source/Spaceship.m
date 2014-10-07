//
//  Spaceship.m
//  Invaders
//
//  Created by Gaurav Garg on 01/05/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Spaceship.h"
#import "Gameplay.h"

@implementation Spaceship
int lastMoveCounter;

- (id)init {
    //self = [super init];
    if (self==[super init]) {
    }
    return self;
}

- (void)update:(CCTime)delta {
    //NSLog(lastBullet.position.x);
    if(lastMoveCounter == 100) {
        self.position = CGPointMake(self.position.x, self.position.y - 30);
        if(self.position.y <= 0) {
            [self gameOver];
            [self removeFromParent];
        }
        lastMoveCounter = 0;
    }
    lastMoveCounter += 1;
    
}
- (void)gameOver {
    CCLOG(@"You lost!");
    [self retry];
}

- (void)retry {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"Spaceship";
}

@end
