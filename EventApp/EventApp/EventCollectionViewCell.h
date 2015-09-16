//
//  EventCollectionViewCell.h
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
@interface EventCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) Event *event;
@end
