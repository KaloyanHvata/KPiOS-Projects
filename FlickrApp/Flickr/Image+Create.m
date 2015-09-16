//
//  Image+Create.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "Image+Create.h"
#import "Author+Create.h"
#import "AppDelegate.h"

@implementation Image (Create)

+ (void)imageWithInfo:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context{
    Image *image = nil;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Creating a one of a kind string to use in the Fetch Request
    NSString *uniqueString = [dict valueForKey:@"id"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", uniqueString];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        //Here we should handle the error
        NSLog(@"There is an error");
    } else if ([matches count]){
        image = [matches lastObject];
        if ([image.dateUpdated compare:[self dateFromString:[dict valueForKey:@"updated"]]] == NSOrderedAscending) {
            //The date in core data is before the date coming from the flickr feed
            //And thats why only image details need to be changed. The author remains the same. Code makes changes only if there is something different in the data.
            image.dateUpdated = [self dateFromString:[dict valueForKey:@"updated"]];
            image.datePublished = [self dateFromString:[dict valueForKey:@"published"]];
            if (![image.title isEqualToString:[dict valueForKey:@"title"]]) {
                image.title = [dict valueForKey:@"title"];
            }
            if (![image.uniqueID isEqualToString:[dict valueForKey:@"id"]]) {
                image.uniqueID = [dict valueForKey:@"id"];
            }
            NSArray *imageURLs = [dict valueForKeyPath:@"link._href"];
            if ([imageURLs count] == 2) {
                if (![image.flickrURL isEqualToString:[imageURLs firstObject]]) {
                    image.flickrURL = [imageURLs firstObject];
                }
                if (![image.imageURL isEqualToString:[self parseURLstring:[imageURLs lastObject]]]) {
                    image.imageURL = [self parseURLstring:[imageURLs lastObject]];
                }
            }
            NSNumber *ratio = [NSNumber numberWithDouble:[self calculateRatio:[dict valueForKey:@"content"]]];
            if ([image.ratio doubleValue] != [ratio doubleValue]) {
                image.ratio = ratio;
            }
            [appDelegate saveContext];
        }
    } else {
        //Seting the image properties
        image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:context];
        image.title = [dict valueForKey:@"title"];
        image.uniqueID = [dict valueForKey:@"id"];
        image.datePublished = [self dateFromString:[dict valueForKey:@"published"]];
        image.dateUpdated = [self dateFromString:[dict valueForKey:@"updated"]];
        image.ratio = [NSNumber numberWithDouble:[self calculateRatio:[dict valueForKey:@"content"]]];
        //Validating the feed
        NSArray *imageURLs = [dict valueForKeyPath:@"link._href"];
        if ([imageURLs count] == 2) {
            image.flickrURL = [imageURLs firstObject];
            image.imageURL = [self parseURLstring:[imageURLs lastObject]];
        }
        
        image.author = [Author authorWithInfo:[dict valueForKey:@"author"] inManagedObjectContext:context];
        [appDelegate saveContext];
    }
}


+ (void)loadImagesFromFlickrArray:(NSArray *)photos inManagedObjectContext:(NSManagedObjectContext *)context{
    //Class method for loading images in the context
    for (NSDictionary *dict in photos) {
        [Image imageWithInfo:dict inManagedObjectContext:context];
    }
}


#pragma mark - Helper methods

+ (NSDate *)dateFromString:(NSString *)dateString{
    //Helper method for properly formating the date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssz"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

+ (double)calculateRatio:(NSDictionary *)dict{
    //Helper method for calculating the ratio (wich is used as a property)
    double width = [self parse:dict forDimension:@"width"];
    double height = [self parse:dict forDimension:@"height"];
    return height/width;
}

+ (double)parse:(NSDictionary *)dict forDimension:(NSString *)stringToParse{
    
    NSString *htmlToParse = [dict valueForKeyPath:@"__text"];
    //NSRange is used with the properties:location and length
    NSRange initialRange = [htmlToParse rangeOfString:[NSString stringWithFormat:@"%@=\"", stringToParse]];
    NSString *remainingString = [htmlToParse substringFromIndex:initialRange.location + initialRange.length];
    NSRange finalRange = [remainingString rangeOfString:@"\""];
    NSString *resultString = [remainingString substringToIndex:finalRange.location];
    //Returning the doible value of the result String
    return [resultString doubleValue];
}

+ (NSString *)parseURLstring:(NSString *)urlString {
    NSString *result;
    NSRange replaceRange = [urlString rangeOfString:@"_b" options:NSBackwardsSearch];
    if (replaceRange.location != NSNotFound){
        result = [urlString stringByReplacingCharactersInRange:replaceRange withString:@""];
       // NSLog(@"%@", result);
    }
    
    return result;
}

@end
