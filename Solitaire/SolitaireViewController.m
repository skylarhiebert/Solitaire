//
//  SolitaireViewController.m
//  Solitaire
//
//  Created by Skylar Hiebert on 4/19/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import "SolitaireViewController.h"
#import "Solitaire.h"
#import "SolitaireView.h"

@interface SolitaireViewController ()

@end

@implementation SolitaireViewController

@synthesize game = _game;
@synthesize gameView = _gameView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.game = [[Solitaire alloc] init];
    
    [self.game freshGame];
    self.gameView.game = _game;
}

- (void)viewDidUnload
{
    [self setGameView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)newGameButton:(id)sender {
    [self.game freshGame];
    self.gameView.game = _game;
}

-(void)movedFan:(NSArray *)f toTableau:(uint)t {
    if ([_game canDropFan:f onTableau:t])
        [_game didDropFan:f onTableau:t];
}

-(void)movedCard:(Card *)c toFoundation:(uint)f {
    if ([_game canDropCard:c onFoundation:f])
        [_game didDropCard:c onFoundation:f];
}

@end
