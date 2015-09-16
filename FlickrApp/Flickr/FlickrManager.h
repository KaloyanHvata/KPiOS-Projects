//
//  FlickrFetcher.h
//  Flickr
//
//  Created by AdrenalineHvata on 5/29/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADDITIONAL_HEIGHT 90

@interface FlickrManager: NSObject

+ (id)manager;

- (void)fetchNewEntriesFromFlickrFeed;

@end
