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
    
}

- (NSUInteger)hash {
    return (_rank - 1)*4 + _suit; // Returns 0 to 51
}

- (BOOL)isEqual:(id)other {
    return _rank == [other rank] && _suit == [other suit];
}

- (NSString *)description {
    
}

- (id)copyWithZone:(NSZone *)zone {
    
}

- (BOOL)isBlack {
    
}

- (BOOL)isRed {
    
}

- (BOOL)isSameColor:(Card *)other {
    
}

+ (NSArray *)deck {
    
}

@end
