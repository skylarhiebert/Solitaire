//
//  Solitaire.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/24/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "Solitaire.h"

@implementation Solitaire {
    NSMutableArray *stock_;
    NSMutableArray *waste_;
    NSMutableArray *foundation_[4];
    NSMutableArray *tablealu_[7];
    NSMutableSet *faceUpCards;
}

- (id)init {
    
}

- (void)freshGame {
    
}

- (BOOL)gameWon {
    
}

- (NSArray *)stock {
    
}

- (NSArray *)waste {
    
}

- (NSArray *)foundation:(uint)i {
    
}

- (NSArray *)tableau:(uint)i {
    
}

- (BOOL)isCardFaceUp:(Card *)card {
    
}

- (NSArray *)fanBeginningWithCard:(Card *)card {
    
}

- (BOOL)canDropCard:(Card *)card onFoundation:(int)i {
    
}

- (void)didDropCard:(Card *)card onFoundation:(int)i {
    
}

- (BOOL)canDropCard:(Card *)card onTableau:(int)i {
    
}

- (BOOL)didDropCard:(Card *)card onTableau:(int)i {
    
}

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i {
    
}

- (BOOL)didDropFan:(NSArray *)cards onTableau:(int)i {
    
}

- (BOOL)canFlipCard:(Card *)card {
    
}

- (BOOL)didFlipCard:(Card *)card {
    
}

- (BOOL)canDealCard {
    
}

- (void)didDealDCard {
    
}

- (void)collectWasteCardsIntoStock {
    
}

@end
