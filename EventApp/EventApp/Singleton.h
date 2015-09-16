//
//  Singleton.h
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"


@interface Singleton : NSObject
@property (strong,nonatomic) NSMutableArray *dates;
@property (strong,nonatomic) NSMutableDictionary *events;

+ (id)eventsBook;

- (void)writeDataTofile;
- (void)loadDataFromFile;
- (void)addEvent:(Event *)newEvent forDate:(NSDate *)date;
- (void)removeEvent:(Event *)event fromDate:(NSDate *)date;
- (NSString *)filePath:(NSString *)fileName;

@end
