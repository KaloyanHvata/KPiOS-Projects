//
//  Author+Create.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "Author+Create.h"
#import <UIKit/UIKit.h>

@implementation Author (Create)

+ (Author *)authorWithInfo:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
    Author *author = nil;
    //Creating a one of a kind String(for id) to use in the Fetch Request
    NSString *uniqueString = [dict valueForKey:@"flickr:nsid"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    request.predicate = [NSPredicate predicateWithFormat:@"authorID = %@", uniqueString];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        //Here should be code handling the error
        NSLog(@"There is an error!");
    } else if ([matches count]){
        author = [matches lastObject];
    } else {
        //Set the Author properties
        author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
        author.authorID = [dict valueForKey:@"flickr:nsid"];
        author.name = [dict valueForKey:@"name"];
        author.authorImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict valueForKey:@"flickr:buddyicon"]]];
    }
    
    return author;
}

@end
