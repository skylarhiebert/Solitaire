//
//  Solitaire.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/24/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "Solitaire.h"
#import "Card.h"

@implementation Solitaire {
    NSMutableArray *stock_;
    NSMutableArray *waste_;
    NSMutableArray *foundation_[4];
    NSMutableArray *tableau_[7];
    NSMutableSet *faceUpCards;
}

- (id)init {
    self = [super init];
    if (self) {
        [self freshGame];
    }
    return self;

}

+ (void)shuffleDeck:(NSMutableArray *)deck {
    /* http://eureka.ykyuen.info/2010/06/19/objective-c-how-to-shuffle-a-nsmutablearray/ */
    // Shuffle the deck
    srandom(time(NULL));
    NSUInteger count = [deck count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [deck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (NSArray *)foundationWithCard:(Card *)card {
    for (int i = 0; i < 4; i++) {
        if ([foundation_[i] containsObject:card]) {
            return foundation_[i];
        }
    }
    return nil;
}

- (NSArray *)tableauWithCard:(Card *)card {
    for (int i = 0; i < 7; i++) {
        if ([tableau_[i] containsObject:card]) {
            return tableau_[i];
        }
    }
    return nil;
}

// Find the tableau or foundation with the card
- (NSArray *)stackWithCard:(Card *)card {
    NSArray *stack = [self foundationWithCard:card];
    if (nil == stack) {
        stack = [self tableauWithCard:card];
    }
    if (nil == stack && [waste_ lastObject] == card) {
        stack = waste_;
    }
    return stack;
}

- (void)freshGame {
    // Get new deck from Card class
    NSMutableArray *deck = (NSMutableArray *) [Card deck];
    
    [Solitaire shuffleDeck:deck];
    
    // Initialize Stock, Waste, Foundation
    stock_ = [[NSMutableArray alloc] init];
    waste_ = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        foundation_[i] = [[NSMutableArray alloc] init];
    }
    
    // Initialize Tableau and take cards from the deck to Tableau
    for (int i = 0; i < 7; i++) {
        tableau_[i] = [[NSMutableArray alloc] init];
        for (int j = 0; j <= i; j++) {
            [tableau_[i] addObject:[deck objectAtIndex:0]];
            [deck removeObjectAtIndex:0];
        }
        // Flip top card of Tableaux
        [faceUpCards addObject:[tableau_[i] lastObject]];
    }
    
    // Place remaining cards in deck to the stock
    [stock_ addObjectsFromArray:deck];
}

- (BOOL)gameWon {
    for (int i = 0; i < 4; i++) {
        if ([foundation_[i] count] < 13) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)stock {
    return stock_;
}

- (NSArray *)waste {
    return waste_;
}

- (NSArray *)foundation:(uint)i {
    return foundation_[i];
}

- (NSArray *)tableau:(uint)i {
    return tableau_[i];
}

- (BOOL)isCardFaceUp:(Card *)card {
    return [faceUpCards containsObject:card];
}

- (NSArray *)fanBeginningWithCard:(Card *)card {
    NSArray *tab;
    
    // Return nil if card not face up
    if ([self isCardFaceUp:card]) 
        return nil;
    
    // Get the tableau that contains the card
    tab = [self tableauWithCard:card];
    if (nil != tab) {
        int index = [tab indexOfObject:card]; // Get index
        NSRange range = NSMakeRange(index, [tab count] - index); // Get Range from index to end of array
        return [tab subarrayWithRange:range]; // Return array
    }
    
    // No tableau with card
    return nil;
}

- (BOOL)canDropCard:(Card *)card onFoundation:(int)i {
    if ( [card rank] != ACE && [card hash] + 1 == [[tableau_[i] lastObject] hash])
        return YES;
    else 
        return NO;
}

- (void)didDropCard:(Card *)card onFoundation:(int)i {
    NSMutableArray *stack = (NSMutableArray *) [self stackWithCard:card];
    [foundation_[i] addObject:card]; // Move to foundation
    [stack removeObject:card]; // Remove from stack
    if ([stack count] > 0)
        [faceUpCards addObject:[stack lastObject]];
}

- (BOOL)canDropCard:(Card *)card onTableau:(int)i {
    if ( [card isSameColor:[foundation_[i] lastObject]] ) 
        return NO;
    else
        return YES;
}

- (void)didDropCard:(Card *)card onTableau:(int)i {
    NSMutableArray *stack = (NSMutableArray *) [self stackWithCard:card]; // Get the stack that contains card
    [tableau_[i] addObject:card]; // Add card to tableau
    [stack removeObject:card]; // remove card from stack
    if ([stack count] > 0)
        [faceUpCards addObject:[stack lastObject]]; // Flip last object (waste or tableau)
}

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i {
    if ( [[cards objectAtIndex:0] isSameColor:[tableau_[i] lastObject]] ) 
        return NO;
    else
        return YES;
}

- (void)didDropFan:(NSArray *)cards onTableau:(int)i {
    // Remove fan from old tableau
    NSMutableArray *oldTab =  (NSMutableArray *) [self tableauWithCard:[cards objectAtIndex:0]];
    [oldTab removeObjectsInArray:cards];
     
    // Add fan to new tableau
    [tableau_[i] addObjectsFromArray:cards];
}

- (BOOL)canFlipCard:(Card *)card {
    NSArray *tab = [self tableauWithCard:card]; // Get the tableau that contains the card
    if ( nil != tab && [tab lastObject] == card )
        return YES;
    return NO;
}

- (void)didFlipCard:(Card *)card {
    [faceUpCards addObject:[[self tableauWithCard:card] lastObject]];
}

- (BOOL)canDealCard { 
    return [stock_ count] > 0;
}

- (void)didDealCard { // Move top card from stock to waste
    // Move last waste card to facedown set
    [faceUpCards removeObject:[waste_ lastObject]];
    
    // Move card from stock to waste
    [waste_ addObject:[stock_ objectAtIndex:0]];
    [stock_ removeObjectAtIndex:0];
    
    // Add new waste card to faceup set
    [faceUpCards addObject:[waste_ lastObject]];
}

- (void)collectWasteCardsIntoStock {
    if ([self canDealCard]) {
        [NSException raise:@"Stock Not Empty" format:@"Stock pile is not empty"];
    } else {
        // Remove waste card from faceup set
        [faceUpCards removeObject:[waste_ lastObject]];
        
        // Move all waste cards to stock
        [stock_ addObjectsFromArray:waste_];
        [waste_ removeAllObjects];
    }
}

@end
