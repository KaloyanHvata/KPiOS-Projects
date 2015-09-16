//
//  Comment.h
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Apartment, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) Apartment *apartment;

@end
