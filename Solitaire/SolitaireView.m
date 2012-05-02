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
#define BUFFER_WIDTH 4
#define DIFF_TAB_FOUND (NUM_TABLEAUS - NUM_FOUNDATIONS)

@implementation SolitaireView {
    NSMutableDictionary *cards;

    CardView *bottomStock;
    CardView *bottomFoundations[NUM_FOUNDATIONS];
    CardView *bottomTableaux[NUM_TABLEAUS];
    
    CGFloat _s;
    CGFloat _w;
    CGFloat _h;
    CGFloat _d;
    CGFloat _f;  
    
    CGPoint touchStartPoint;
    CGPoint startCenter;
    Card *touchedCard;
    NSArray *touchedFan;
}

@synthesize game = _game;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
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

#pragma mark Initialization

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
    
    [self computeCardLayout];
}

- (void)initializeView {
    [self computeSizes];
    
    [self computeCardLayout];
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

- (void)addBottomCardsToSubview {
    // Create bottom card images
    bottomStock = [[CardView alloc] 
                   initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h) 
                   andCard:nil];
    [self addSubview:bottomStock];
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + (i*_w) + (i*_d);
        CGFloat tableauY = MARGIN + _h + _s;
        bottomTableaux[i] = [[CardView alloc] 
                             initWithFrame:CGRectMake(tableauX, tableauY, _w, _h) 
                             andCard:nil];
        [self addSubview:bottomTableaux[i]];
    }
    
    CGFloat foundationY = MARGIN;
    CGFloat width = self.bounds.size.width;
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        //CGFloat foundationX = MARGIN + ((i+DIFF_TAB_FOUND)*_w) + ((i+DIFF_TAB_FOUND)*_d);
        CGFloat foundationX = width - MARGIN - (i*(BUFFER_WIDTH)) - ((i+1)*_w);
        bottomFoundations[i] = [[CardView alloc] 
                                initWithFrame:CGRectMake(foundationX, foundationY, _w, _h) 
                                andCard:nil];
        [self addSubview:bottomFoundations[i]];
    }
}

#pragma mark Helper Functions

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

#pragma mark Layout Functions

- (void)rotateLayout {
    [self computeSizes];
    [self computeBottomCardLayout];
    [self computeCardLayout];
}

- (void)computeSizes {
    //_w = ((self.bounds.size.width - 2*MARGIN) / 7.0) - _d*2;
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    if ( width > height ) {
        _h = (height - 2*MARGIN) / 5.5; // Total height is 5.5 card heights
        _w = _h * ASPECT_RATIO_X;
    } else {
        _w = ((width - 2*MARGIN) / 7.0) - BUFFER_WIDTH;
        _h = _w * ASPECT_RATIO_Y;
    }

    _s = _h/2.0;
    _d = (self.bounds.size.width - 2*MARGIN - 7*_w) / 6;
    _f = _h/4.0;
    
}

- (void)computeBottomCardLayout {
    CardView *cv;
    
    bottomStock.frame = CGRectMake(MARGIN, MARGIN, _w, _h);
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        cv = bottomTableaux[i]; 
        CGFloat tableauX = MARGIN + (i*_w) + (i*_d);
        CGFloat tableauY = MARGIN + _h + _s;
        bottomTableaux[i].frame = CGRectMake(tableauX, tableauY, _w, _h);
    }
    
    CGFloat foundationY = MARGIN;
    CGFloat width = self.bounds.size.width;
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = width - MARGIN - (i*(BUFFER_WIDTH)) - ((i+1)*_w);
        bottomFoundations[i].frame = CGRectMake(foundationX, foundationY, _w, _h);
    }
}

- (void)computeCardLayout {
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
        [self bringSubviewToFront:cv];
    }
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + (i*_w) + (i*_d);
        CGFloat tableauY = MARGIN + _h + _s;
        for (int j = 0; j < [[_game tableau:i] count]; j++) {
            Card *c = [[_game tableau:i] objectAtIndex:j];
            tableauY = MARGIN + _h + _s + j*_f;
            cv = [cards objectForKey:c];
            cv.frame = CGRectMake(tableauX, tableauY, _w, _h); 
            [self bringSubviewToFront:cv];
        }
    }
    
    CGFloat foundationY = MARGIN;
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
//        CGFloat foundationX = MARGIN + ((i+DIFF_TAB_FOUND)*_w) + ((i+DIFF_TAB_FOUND+2)*_d);
        CGFloat foundationX = self.bounds.size.width - MARGIN - (i*(BUFFER_WIDTH)) - ((i+1)*_w);
        for (Card *c in [_game foundation:i]) {
            cv = [cards objectForKey:c];
            cv.frame = CGRectMake(foundationX, foundationY, _w, _h);
            [self bringSubviewToFront:cv];
        }
    }
}

#pragma mark Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView {
    touchStartPoint = [[touches anyObject] locationInView:self];
    startCenter = cardView.center;
    
    Card *c = [cardView card];
    if ([_game.stock containsObject:c] || cardView == bottomStock ) {
        [_delegate moveStockToWaste];
        [[cards objectForKey:[_game.waste lastObject]] setNeedsDisplay]; // Redraw new waste card
        [[cards objectForKey:[_game.stock lastObject]] setNeedsDisplay]; // Redraw top of Stock
    }    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView {
    // Pick up the fan and move it
    CGPoint touchPoint = [[touches anyObject] locationInView:self]; 
    CGPoint delta = CGPointMake(touchPoint.x - touchStartPoint.x, touchPoint.y - touchStartPoint.y);
    CGPoint newCenter = CGPointMake(startCenter.x + delta.x, startCenter.y + delta.y);
    
    NSArray *fan = [_game fanBeginningWithCard:[cardView card]];
    // Card is on the waste
    if (nil == fan && [_game.waste containsObject:[cardView card]]) {
        cardView.center = newCenter;
    } else {    // Card is in a fan        
        for (int i = 0; i < [fan count]; i++) {
            CardView *cv = [cards objectForKey:[fan objectAtIndex:i]];
            cv.center = CGPointMake(newCenter.x, newCenter.y + (i * _f));
            [self bringSubviewToFront:cv];
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView  {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView  {
//    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    Card *c = [cardView card];
    
    if (!c.faceUp) {
        if ([_delegate flipCard:c]) {
            [[cards objectForKey:c] setNeedsDisplay];
            return; // Break early 'cause we're just flipping
        }
    }
    
    NSArray *fan = [_game fanBeginningWithCard:c];
    CGFloat fanHeight = _h + [fan count] * (_f - 1);
    CGRect fanRect = CGRectMake(cardView.frame.origin.x, cardView.frame.origin.y, _w, fanHeight);
    
    if ([fan count] == 1 && cardView.center.y < MARGIN + _h + (_s/2)) { // Check Foundation
        for (int i = 0; i < NUM_FOUNDATIONS; i++) { // Iterate through foundations
            CardView *cvFound = bottomFoundations[i];
            if ( CGRectIntersectsRect(cvFound.frame, fanRect) ) {// See if foundation intersects with card
                [_delegate movedCard:[cardView card] toFoundation:i]; // Move card
            }
        }
    } else { // May intersect with tableau
        for (int i = 0; i < NUM_TABLEAUS; i++) {
            NSArray *tab = [_game tableau:i];
            CardView *cvTab = [cards objectForKey:[tab lastObject]];
            if ( cvTab == [cards objectForKey:[fan lastObject]] ) continue; // If touched CardView == lastCardView in Tableau
            
            if ( [tab count] == 0 ) 
                cvTab = bottomTableaux[i]; // Empty tableau
            
            CGFloat tabHeight = _h + [tab count] * (_f - 1);               
            CGRect tabRect = CGRectMake(cvTab.frame.origin.x, cvTab.frame.origin.y, _w, tabHeight);
            if ( CGRectIntersectsRect(tabRect, fanRect) ) {
                [_delegate movedFan:fan toTableau:i];
            }
        }
    }

            
//            for (int j = 0; j < [tab count]; j++) {
//                CardView *cvTab = [cards objectForKey:[tab objectAtIndex:j]];
//                for (Card *c2 in fan) {
//                    CardView *cvFan = [cards objectForKey:c2];
//                    if (cvTab == cvFan) continue; // Don't check self tab
//                    if (CGRectIntersectsRect(cvTab.frame, fanRect)) {
//                        
//                    }
//                }
//            }

    
    // Fan touches Tableau
//    if (cardView.center.y > MARGIN + _h + (_s/2)) { // In Foundations
//        for (int i = 0; i < NUM_FOUNDATIONS; i++) {
//            NSArray *tab = [_game tableau:i];
//            for (int j = 0; j < [tab count]; j++) {
//                CardView *cvTab = [cards objectForKey:[tab objectAtIndex:j]];
//                for (Card *c2 in fan) {
//                    CardView *cvFan = [cards objectForKey:c2];
//                    if (cvTab == cvFan) continue; // Don't check self tab
//                    if (CGRectIntersectsRect(cvTab.frame, cvFan.frame)) {
//                        [_delegate movedFan:fan toTableau:i];
//                    }
//                }
//            }
//        }
//    } else {
//        for (int i = 0; i < NUM_TABLEAUS; i++) {
//            NSArray *tab = [_game tableau:i];
//            for (int j = 0; j < [tab count]; j++) {
//                CardView *cvTab = [cards objectForKey:[tab objectAtIndex:j]];
//                for (Card *c2 in fan) {
//                    CardView *cvFan = [cards objectForKey:c2];
//                    if (cvTab == cvFan) continue; // Don't check self tab
//                    if (CGRectIntersectsRect(cvTab.frame, cvFan.frame)) {
//                        [_delegate movedFan:fan toTableau:i];
//                    }
//                }
//            }
//        }
//    }
    

    [self computeCardLayout];
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
