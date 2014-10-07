//
//  Gameplay.m
//  Invaders
//
//  Created by Gaurav Garg on 16/04/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import <CoreMotion/CoreMotion.h>
#import "CCActionManager.h"
//int Score = 0;
int shooters = 11;

@implementation Gameplay
{
    CCPhysicsNode *_physicsNode;
    CCNode *_mainShooter;
    CCNode *lastBullet;
    CMMotionManager *_motionManager;
    CCLabelTTF *_label;
    CCNode *_levelNode;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    _label= [CCLabelTTF labelWithString:@"X" fontName:@"Arial" fontSize:48];
    [self addChild:_label];
    _motionManager = [[CMMotionManager alloc] init];
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    _physicsNode.collisionDelegate = self;

}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if(lastBullet==NULL)
    {
    CCNode* bullet = [CCBReader load:@"Bullet"];
    bullet.position =  _mainShooter.position;
        //ccpAdd(_mainShooter.position, ccp(0, 10));
    [_physicsNode addChild:bullet];
    lastBullet = bullet;
    [self shootSound];
    }

}

-(CCNode*)LastBullet {
    return lastBullet;
}

-(void)removeLastBullet {
    [lastBullet removeFromParent];
    lastBullet = NULL;
}

- (void)update:(CCTime)delta {
    if(lastBullet!=NULL)
    {
        lastBullet.position = ccp(lastBullet.position.x, lastBullet.position.y + 6);

        if(lastBullet.position.y>550)
        {
            [self removeLastBullet];
        }
    }
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = _label.position.x + acceleration.y * 1000 * delta;
    newXPosition = clampf(newXPosition, 0, self.contentSize.width);
    _label.position = CGPointMake(newXPosition, _label.position.y);
}

- (void)onEnter
{
    [super onEnter];
    _label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [_motionManager startAccelerometerUpdates];
}

- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Spaceship:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    [self spaceshipRemoved:nodeA];
    [self removeLastBullet];
    [self shotSound];
    Score = Score+1;
    
    if(Score%shooters == 0)
    {
        CCLOG(@"You Won!");
        [self retry];
    }
    //CCLOG(strFromInt);

}

- (void)spaceshipRemoved:(CCNode *)ship {
    [ship removeFromParent];
}

- (void)retry {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

-(IBAction)shootSound
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFile;
    soundFile = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"Shoot", CFSTR ("m4a"), NULL);
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFile, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(IBAction)shotSound
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFile;
    soundFile = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"invaderkilled", CFSTR ("wav"), NULL);
    UInt32 soundID2;
    AudioServicesCreateSystemSoundID(soundFile, &soundID2);
    AudioServicesPlaySystemSound(soundID2);
}


@end
