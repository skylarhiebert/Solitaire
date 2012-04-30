//
//  SolitaireView.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "CardView.h"
#import "SolitaireDelegate.h"

@class Solitaire;

@interface SolitaireView : UIView

@property (strong, nonatomic) Solitaire *game;
@property (weak, nonatomic) id <SolitaireDelegate> delegate;

- (void)addToSubViewForCard:(Card *)c;

- (void)setGame:(Solitaire *)game;
- (void)initializeView;
- (void)addToSubViewForCard:(Card *)c;
- (void)addBottomCardsToSubview;

- (void)iterateGameWithBlock:(void (^)(Card *c))block;

- (void)rotateLayout;
- (void)computeBottomCardLayout;
- (void)computeCardLayout;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event withCardView:(CardView *)cardView;

@end
