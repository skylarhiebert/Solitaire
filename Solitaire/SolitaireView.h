//
//  SolitaireView.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class Solitaire;

@interface SolitaireView : UIView

@property (strong, nonatomic) Solitaire *game;

- (void)iterateGameWithBlock:(void (^)(Card *c))block;
- (void)addToSubViewForCard:(Card *)c;
- (void)rotateLayout;

@end
