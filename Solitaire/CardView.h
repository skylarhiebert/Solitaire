//
//  CardView.h
//  Solitaire
//
//  Created by Skylar Hiebert on 4/25/12.
//  Copyright (c) 2012 skylarhiebert.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASPECT_RATIO_X 0.71591
#define ASPECT_RATIO_Y 1.396825

@class Card;

@interface CardView : UIView

@property (strong, nonatomic) UIImage *cardImage;
@property (strong, nonatomic) Card *card;

- (id)initWithFrame:(CGRect)frame andCard:(Card *)card;

- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

+ (UIImage *)backImage;
+ (UIImage *)emptyImage;

@end
