//
//  SearchViewController.h
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

- (void)searchButtonPressedWithMinRoomsCount:(int)minRooms maxRoomsCount:(int)maxRooms andPriceFrom:(int)minPrice toPrice:(int)maxPrice andLocation:(NSString *)location;

@end

@interface SearchViewController : UIViewController

@property (nonatomic, weak) id <SearchDelegate> delegate;

@end
