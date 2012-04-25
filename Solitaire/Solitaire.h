//
//  Solitaire.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/24/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Solitaire : NSObject

- (id)init;

+ (void)shuffleDeck:(NSMutableArray *)deck;
- (void)freshGame;
- (BOOL)gameWon;

- (NSArray *)stock;
- (NSArray *)waste;
- (NSArray *)foundation:(uint)i;
- (NSArray *)tableau:(uint)i;

- (NSArray *)fanBeginningWithCard:(Card *)card;

- (BOOL)canDropCard:(Card *)card onFoundation:(int)i;
- (void)didDropCard:(Card *)card onFoundation:(int)i;

- (BOOL)canDropCard:(Card *)card onTableau:(int)i;
- (void)didDropCard:(Card *)card onTableau:(int)i;

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i;
- (void)didDropFan:(NSArray *)cards onTableau:(int)i;

- (BOOL)canFlipCard:(Card *)card;
- (void)didFlipCard:(Card *)card;

- (BOOL)canDealCard;
- (void)didDealCard;

- (void)collectWasteCardsIntoStock;

@end
