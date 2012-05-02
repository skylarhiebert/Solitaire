//
//  SolitaireDelegate.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol SolitaireDelegate <NSObject>
 
- (BOOL)flipCard:(Card *)c;
- (void)movedFan:(NSArray *)f toTableau:(uint)t;
- (void)movedCard:(Card *)c toFoundation:(uint)f;
- (void)moveStockToWaste;

@end
