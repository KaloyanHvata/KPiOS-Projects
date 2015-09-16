//
//  AppDelegate.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "AppDelegate.h"
#import "Event.h"
#import "Singleton.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   Singleton  *singleton = [Singleton eventsBook];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FileWasLoadedOnce"]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePathArray = [singleton filePath:@"EventsDates"];
        NSString *filePathDictionary = [singleton filePath:@"Events"];
        if ([fileManager fileExistsAtPath:filePathArray] && [fileManager fileExistsAtPath:filePathDictionary]) {
            [singleton loadDataFromFile];
        } else {
            [[NSFileManager defaultManager] createFileAtPath:filePathArray contents:nil attributes:nil];
            [[NSFileManager defaultManager] createFileAtPath:filePathDictionary contents:nil attributes:nil];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FileWasLoadedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *initialData = [[NSBundle mainBundle] pathForResource:@"InitialData" ofType:@"plist"];
        NSArray *eventsArray = [[NSArray alloc] initWithContentsOfFile:initialData];
        NSArray *datesStrings = @[@"Sun-26-Apr", @"Mon-27-Apr", @"Tue-28-Apr", @"Mon-27-Apr", @"Mon-27-Apr", @"Tue-28-Apr"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE-dd-MMM"];
        int current = 0;
        
        for (NSDictionary *currentEvent in eventsArray) {
            Event *eventToAdd = [[Event alloc]initWithTitle:currentEvent[@"title"]  withImage:currentEvent[@"image"] withDescription:currentEvent[@"description"] withRelatedPerson:currentEvent[@"relatedPerson"] withDuration:currentEvent[@"duration"]];
            NSDate *date = [formatter dateFromString:datesStrings[current]];
            current++;
            [singleton addEvent:eventToAdd forDate:date];
        }
        [singleton writeDataTofile];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    Singleton *singleton = [Singleton eventsBook];
    [singleton writeDataTofile];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    Singleton *singleton = [Singleton eventsBook];
    [singleton writeDataTofile];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
