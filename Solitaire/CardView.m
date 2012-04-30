//
//  CardView.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "CardView.h"
#import "SolitaireView.h"
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
        if ( nil == card ) {
            _cardImage = [CardView emptyImage];
//            [self setUserInteractionEnabled:NO];
        } else {
            _cardImage = [UIImage imageNamed:[card description]];
            _card = card;
        }
        self.opaque = NO;
    }
    return self;
}

- (NSUInteger)hash {
    return [_card hash]; // Returns 0 to 51
}

- (BOOL)isEqual:(id)other {
    
    // Travis told me to do this
    if ([other class] == [Card class] ) {
        return [_card isEqual:other];
    }
    
    return [_card isEqual:[other card]];
}

- (void)drawRect:(CGRect)rect
{
    if (nil == _card || _card.faceUp)
        [self.cardImage drawInRect:rect];
    else {
        NSLog(@"drawingFaceUp:%@", _card);
        [[CardView backImage] drawInRect:rect];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"CARDVIEW touchesBegan: withEvent:");
    SolitaireView *parentView = (SolitaireView *) [self superview];
    [parentView touchesBegan:touches withEvent:event withCardView:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    SolitaireView *parentView = (SolitaireView *) [self superview];
    [parentView touchesMoved:touches withEvent:event withCardView:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    SolitaireView *parentView = (SolitaireView *) [self superview];
    [parentView touchesCancelled:touches withEvent:event withCardView:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    SolitaireView *parentView = (SolitaireView *) [self superview];
    [parentView touchesEnded:touches withEvent:event withCardView:self];
}

// Static method for referencing the image on back of all cards
+ (UIImage *)backImage {
    static UIImage *backImage = nil;
    if (nil == backImage) {
        backImage = [UIImage imageNamed:@"back-blue-150-4"];
    }
    
    return backImage;    
}

// Static method for referencing the image of a blank card
+ (UIImage *)emptyImage {
    static UIImage *backImage = nil;
    if (nil == backImage) {
        backImage = [UIImage imageNamed:@"empty-card-150"];
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
