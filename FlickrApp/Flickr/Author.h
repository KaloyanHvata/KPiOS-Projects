//
//  Author.h
//  Flickr
//
//  Created by AdrenalineHvata on 5/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * authorID;
@property (nonatomic, retain) NSData * authorImage;
@property (nonatomic, retain) NSSet *images;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
