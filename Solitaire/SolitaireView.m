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

#define MARGIN 20
#define BUFFER_WIDTH 2
#define DIFF_TAB_FOUND (NUM_TABLEAUS - NUM_FOUNDATIONS)

@implementation SolitaireView {
    NSMutableDictionary *cards;

    CardView *bottomStock;
    CardView *bottomFoundations[NUM_FOUNDATIONS];
    CardView *bottomTableaux[NUM_TABLEAUS];
    
    CGFloat _s;
    CGFloat _w;
    CGFloat _h;
    CGFloat _f;    
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

- (void)initializeView {
    [self computeSizes];
    
    [self computeLayoutForSubviews];
}

- (void)addToSubViewForCard:(Card *)c {  
    // If card is not already in our view
    if ( ![cards objectForKey:c] ) {
        CardView *cv = [[CardView alloc] 
                        initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _f) 
                        andCard:c];
        [cards setObject:cv forKey:c];
        [self addSubview:cv];
    }
}

- (void) addBottomCardsToSubview {
    // Create bottom card images
    bottomStock = [[CardView alloc] 
                   initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h) 
                   andCard:nil];
    [self addSubview:bottomStock];
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + (i*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH;
        CGFloat tableauY = MARGIN + _h + _s;
        bottomTableaux[i] = [[CardView alloc] 
                             initWithFrame:CGRectMake(tableauX, tableauY, _w, _h) 
                             andCard:nil];
        [self addSubview:bottomTableaux[i]];
    }
    
    CGFloat foundationY = MARGIN;
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = MARGIN + ((i+DIFF_TAB_FOUND)*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH;
        bottomFoundations[i] = [[CardView alloc] 
                                initWithFrame:CGRectMake(foundationX, foundationY, _w, _h) 
                                andCard:nil];
        [self addSubview:bottomFoundations[i]];
    }
}

- (void)awakeFromNib {
    [self initializeView];
//    Card *c = [[Card alloc] initWithRank:KING Suit:SPADES];
//    c.faceUp = YES;
//    
//    CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 214) andCard:c];
//    
//    [self addSubview:cardView];
    
    
//    bottomCard = [UIImage imageNamed:@"empty-card-150"];
}

- (void)setGame:(Solitaire *)game {
    _game = game;
    cards = [[NSMutableDictionary alloc] init];
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    [self addBottomCardsToSubview];
    
    [self iterateGameWithBlock:^(Card *c) {
        [self addToSubViewForCard:c];
    }];
    
    [self computeLayoutForSubviews];
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

- (void)computeSizes {
    _w = ((self.bounds.size.width - 2*MARGIN) / 7.0) - BUFFER_WIDTH*2;
    _h = (self.bounds.size.height - 2*MARGIN) / 5.5; // Total height is 5.5 card heights
    _s = _h/2.0;
    _f = _h/4.0;
    
}

- (void)computeLayoutForSubviews {
    CardView *cv;
    
    for (Card *c in _game.stock) {
        cv = [cards objectForKey:c];
        cv.frame = CGRectMake(MARGIN, MARGIN, _w, _h);
    }
    
    CGFloat wasteX = MARGIN + _w + BUFFER_WIDTH;
    CGFloat wasteY = MARGIN;
    for (Card *c in _game.waste) {
        cv = [cards objectForKey:c];
        cv.frame = CGRectMake(wasteX, wasteY, _w, _h);
    }
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + (i*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH;
        CGFloat tableauY = MARGIN + _h + _s;
        for (int j = 0; j < [[_game tableau:i] count]; j++) {
            Card *c = [[_game tableau:i] objectAtIndex:j];
            tableauY = MARGIN + _h + _s + j*_f;
            cv = [cards objectForKey:c];
            cv.frame = CGRectMake(tableauX, tableauY, _w, _h); 
        }
    }
    
    CGFloat foundationY = MARGIN;
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = MARGIN + ((i+DIFF_TAB_FOUND)*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH; 
        for (Card *c in [_game foundation:i]) {
            cv = [cards objectForKey:c];
            cv.frame = CGRectMake(foundationX, foundationY, _w, _h);
        }
    }
}

//- (void)layoutSubviews {
//    
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    // Stock Image
//    [bottomCard drawInRect:CGRectMake(MARGIN, MARGIN, _w, _h)];
//    
//    CGFloat wasteX = MARGIN + _w + BUFFER_WIDTH;
//    CGFloat wasteY = MARGIN;
//    // Waste Image
//    [bottomCard drawInRect:CGRectMake(wasteX, wasteY, _w, _h)];
//    
//    CGFloat tableauY = MARGIN + _h + _s;
//    for (int i = 0; i < NUM_TABLEAUS; i++) {
//        CGFloat tableauX = MARGIN + (i*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH;
//        [bottomCard drawInRect:CGRectMake(tableauX, tableauY, _w, _h)];
//    }
//    
//    CGFloat foundationY = MARGIN;
//    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
//        CGFloat foundationX = MARGIN + ((i+DIFF_TAB_FOUND)*_w) + (i*BUFFER_WIDTH*2) - BUFFER_WIDTH;
//        [bottomCard drawInRect:CGRectMake(foundationX, foundationY, _w, _h)];
//    }
//}

@end
