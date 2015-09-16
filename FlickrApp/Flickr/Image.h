//
//  Image.h
//  Flickr
//
//  Created by AdrenalineHvata on 5/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSDate * dateUpdated;
@property (nonatomic, retain) NSString * flickrURL;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * ratio;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uniqueID;
@property (nonatomic, retain) Author *author;

@end
