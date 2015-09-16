//
//  Singleton.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
+(id)eventsBook{
    static Singleton *eventsBook = nil;
    @synchronized (self){
        if(eventsBook == nil){
            eventsBook = [[self alloc]init];
        }
    }
    return eventsBook;
}
-(instancetype) init{
    self = [super init];
    if(self){
        _dates = [[NSMutableArray alloc]init];
        _events = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSString *)filePath:(NSString *)fileName{
    NSString *filepath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filepath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return filepath;
}

- (void)writeDataTofile
{
    NSString *filePathArray = [self filePath:@"EventsDates"];
    NSString *filePathDictionary = [self filePath:@"Events"];
    [NSKeyedArchiver archiveRootObject:self.dates toFile:filePathArray];
    [NSKeyedArchiver archiveRootObject:self.events toFile:filePathDictionary];
}

- (void)loadDataFromFile
{
    NSString *filePathArray = [self filePath:@"EventsDates"];
    NSString *filePathDictionary = [self filePath:@"Events"];
    self.dates = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathArray];
    self.events = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathDictionary];
}
- (void)addEvent:(Event *)newEvent forDate:(NSDate *)date
{
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE-dd-MMM"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDate *dateToWrite = [formatter dateFromString:dateString];
    
    if ([self.dates containsObject:dateToWrite]) {
        NSMutableArray *eventsForDate = [self.events objectForKey:dateToWrite];
        [eventsForDate addObject:newEvent];
        [self.events setObject:eventsForDate forKey:dateToWrite];
    } else {
        [self.dates addObject:dateToWrite];
        self.dates = [[self.dates sortedArrayUsingComparator: ^(NSDate *d1, NSDate *d2) {
            return -1 * [d1 compare:d2];
        }] mutableCopy];
        
        NSMutableArray *eventsForDate = [[NSMutableArray alloc] init];
        [eventsForDate addObject:newEvent];
        [self.events setObject:eventsForDate forKey:dateToWrite];
    }
}

- (void)removeEvent:(Event *)event fromDate:(NSDate *)date
{
    if ([self.dates containsObject:date]) {
        NSMutableArray *eventsForDate = [self.events objectForKey:date];
        [eventsForDate removeObject:event];
        if (![eventsForDate count]) {
            [self.dates removeObject:date];
            [self.events removeObjectForKey:date];
        } else {
            [self.events setObject:eventsForDate forKey:date];
        }
    }
}

@end
