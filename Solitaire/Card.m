//
//  Card.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/19/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize rank = _rank;
@synthesize suit = _suit;

- (id)initWithRank:(uint)r Suit:(uint)s {
    self = [super init];
    if (self) {
        _rank = r;
        _suit = s;
    }
    return self;
}

- (NSUInteger)hash {
    return (_suit - 1)*13 + _rank; // Returns 0 to 51
}

- (BOOL)isEqual:(id)other {
    return _rank == [other rank] && _suit == [other suit];
}

- (NSString *)description {
    NSString *s;
    NSString *r;
    switch (_suit) {
        case SPADES:
            s = @"Spades";
            break;
        case CLUBS:
            s = @"Clubs";
            break;
        case DIAMONDS:
            s = @"Diamonds";
            break;
        case HEARTS:
            s = @"Hearts";
            break;
        default:
            s = @"Unknown";
            break;
    }
    switch (_rank) {
        case ACE:
            r = @"Ace";
            break;
        case JACK:
            r = @"Jack";
            break;
        case QUEEN:
            r = @"Queen";
            break;
        case KING:
            r = @"King";
            break;
        default:
            r = [NSString stringWithFormat:@"%d", r];
            break;
    }
    
    return [NSString stringWithFormat:@"%@ of %@", r, s];
    
}

- (id)copyWithZone:(NSZone *)zone {
    Card *copy = [[Card allocWithZone:zone] initWithRank:_rank Suit:_suit];
    return copy;
}

- (BOOL)isBlack {
    return _suit == SPADES || _suit == CLUBS;    
}

- (BOOL)isRed {
    return _suit == DIAMONDS || _suit == HEARTS;
}

- (BOOL)isSameColor:(Card *)other {
    return ([self isRed] && [other isRed]) || ([self isBlack] && [other isBlack]);
}

+ (NSArray *)deck {
    NSMutableArray *deck;
    for (int i = SPADES; i <= HEARTS; i++) {
        for (int j = ACE; j <= KING; j++) {
            [deck addObject:[[Card alloc] initWithRank:j Suit:i]];
        }
    }
    
    return deck; 
}

@end
