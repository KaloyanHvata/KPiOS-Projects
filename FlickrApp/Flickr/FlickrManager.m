//
//  FlickrFetcher.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/29/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "FlickrManager.h"
#import "XMLDictionary.h"
#import "Image+Create.h"
#import "AppDelegate.h"

@implementation FlickrManager 

+ (id)manager
{
    static FlickrManager *sharedManager = nil;
    
    @synchronized(self) {
        if ( sharedManager == nil )
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (void)fetchNewEntriesFromFlickrFeed
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/feeds/photos_public.gne"];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *xmlResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *xmlEntries = [NSDictionary dictionaryWithXMLData:xmlResults];
        NSArray *entries = [xmlEntries valueForKeyPath:@"entry"];
        //Log for the entries to make the model
        //NSLog(@"%@", entries);
        //Using different context for saving each separate entry and then perform batch save to the main context
        NSManagedObjectContext* backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundContext.parentContext = appDelegate.managedObjectContext;
        [Image loadImagesFromFlickrArray:entries inManagedObjectContext:appDelegate.managedObjectContext];
        [appDelegate saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshingFeedDidEndNotification" object:nil];
    });
}

@end
