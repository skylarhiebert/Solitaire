//
//  SolitaireViewController.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/19/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolitaireDelegate.h"

@class Solitaire;
@class SolitaireView;

@interface SolitaireViewController : UIViewController <SolitaireDelegate>

@property (strong, nonatomic) Solitaire *game;

@property (weak, nonatomic) IBOutlet SolitaireView *gameView;
- (IBAction)newGameButton:(id)sender;

@end
