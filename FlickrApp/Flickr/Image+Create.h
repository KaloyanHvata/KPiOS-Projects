//
//  Image+Create.h
//  Flickr
//
//  Created by AdrenalineHvata on 5/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "Image.h"

@interface Image (Create)
//Using Categories because the code is only related with the model classes and since they are only 2 it's easy to maintan.
+ (void)imageWithInfo:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadImagesFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context;

@end
