//
//  Shooter.m
//  Invaders
//
//  Created by Gaurav Garg on 16/04/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Shooter.h"

@implementation Shooter
{
CCNode *_mainShooter;
}
- (id)init {
    //self = [super init];
    if (self==[super init]) {
        CCLOG(@"Shooter created");
    }
    return self;
}


-(void)Shoot:(CCNode*)game {
    CCNode* bullet = [CCBReader load:@"Bullet"];
    bullet.position = _mainShooter.position;
    [game addChild:bullet];
    
}

@end
