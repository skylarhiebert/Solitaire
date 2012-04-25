//
//  CardView.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "CardView.h"
#import "Card.h"

// Shamelessly copied from TouchFoo
@implementation CardView {
    CGPoint touchStartPoint;
    CGPoint startCenter;
}

@synthesize cardImage = _cardImage;
@synthesize card = _card;

- (id)initWithFrame:(CGRect)frame andCard:(Card *)card
{
    self = [super initWithFrame:frame];
    if (self) {
        _cardImage = [UIImage imageNamed:[card description]];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_card.faceUp)
        [self.cardImage drawInRect:rect];
    else 
        [[CardView backImage] drawInRect:rect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchStartPoint = [[touches anyObject] locationInView:self.superview];
    startCenter = self.center;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.superview]; 
    CGPoint delta = CGPointMake(touchPoint.x - touchStartPoint.x, touchPoint.y - touchStartPoint.y);
    CGPoint newCenter = CGPointMake(startCenter.x + delta.x, startCenter.y + delta.y);
    self.center = newCenter;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

+ (UIImage *)backImage {
    static UIImage *backImage = nil;
    if (nil == backImage) {
        backImage = [UIImage imageNamed:@"back-blue-150-4"];
    }
    
    return backImage;    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
