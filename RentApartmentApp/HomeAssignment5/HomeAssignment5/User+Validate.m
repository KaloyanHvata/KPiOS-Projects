//
//  User+Validate.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "User+Validate.h"
#import "AppDelegate.h"

@implementation User (Validate)

+ (BOOL)checkForExistingUsername:(NSString *)username
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userName = %@", username];
    request.sortDescriptors = nil;
    NSArray* matches = [context executeFetchRequest:request error:nil];
    if ([matches count] > 1) {
        return YES;
    } else {
        return NO;
    }
    
}

@end
