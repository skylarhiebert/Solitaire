//
//  SolitaireView.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "SolitaireView.h"
#import "Solitaire.h"
#import "CardView.h"

@implementation SolitaireView {
    NSMutableSet *cards;
}

@synthesize game = _game;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addToSubViewForCard:(Card *)c {
    CardView *cv = [[CardView alloc] 
                    initWithFrame:CGRectMake(20, 20, 150, 215) 
                    andCard:c];
    [cards addObject:cv];
    [self addSubview:cv];
}

//- (void)awakeFromNib {
//    Card *c = [[Card alloc] initWithRank:KING Suit:SPADES];
//    c.faceUp = YES;
//    
//    CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 214) andCard:c];
//    
//    [self addSubview:cardView];
//               
//}

- (void)setGame:(Solitaire *)game {
    _game = game;
    cards = [[NSMutableSet alloc] init];
    
    [self iterateGameWithBlock:^(Card *c) {
        [self addToSubViewForCard:c];
    }];
}

// Thanks Travis!
- (void)iterateGameWithBlock:(void (^)(Card *c))block { 

    for (Card *c in _game.stock) {
        block(c);
    }

    for (Card *c in _game.waste) {
        block(c);
    }

    for (int i = 0; i < NUM_TABLEAUS; i++) {
        for (Card *c in [_game tableau:i]) {
            block(c);
        }
    }

    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        for (Card *c in [_game foundation:i]) {
            block(c);
        }
    }
}

//- (void)layoutSubviews {
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
