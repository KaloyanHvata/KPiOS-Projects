//
//  AppDelegate+Update.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "AppDelegate+Update.h"
#import "Apartment.h"
#import "Comment.h"
#import "User.h"

#define NAME_MIN_LENGTH 5
#define LOCATION_MIN_LENGTH 8
#define DETAILS_MIN_LENGTH 100
#define MAX_PRICE 998
#define MAX_ROOMCOUNT 5
#define COMMENT_MIN_LENGTH 50
#define USERNAME_MIN_LENGTH 4
#define FIRSTNAME_MIN_LENGTH 4
#define LASTNAME_MIN_LENGTH 4
#define ADDRESS_MIN_LENGTH 5
#define MAX_AGE 100

@implementation AppDelegate (Update)

- (NSString *)generateRandomStringWithLength:(NSInteger)len {
    static NSString *letters = @"abcdefg hijklmno pqrstuv wxyzAB CDEFGH IJKLMNO PQRST UVWX YZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

- (NSInteger)generateRandomLength:(NSInteger)minLenght
{
    NSInteger random = arc4random() % 10;
    if (random == 0) {
        random = 1;
    }
    return random * minLenght;
}


-(void)addRandomApartment
{
    //Apartment
    Apartment *apartmentToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"Apartment" inManagedObjectContext:self.managedObjectContext];
    apartmentToAdd.name = [self generateRandomStringWithLength:[self generateRandomLength:NAME_MIN_LENGTH]];
    apartmentToAdd.location = [self generateRandomStringWithLength:[self generateRandomLength:LOCATION_MIN_LENGTH]];
    apartmentToAdd.detailInfo = [self generateRandomStringWithLength:[self generateRandomLength:DETAILS_MIN_LENGTH]];
    apartmentToAdd.image = UIImagePNGRepresentation([UIImage imageNamed:@"no-image"]);
    apartmentToAdd.price = [NSNumber numberWithInt:arc4random_uniform(MAX_PRICE) + 1];
    apartmentToAdd.roomsCount = [NSNumber numberWithInt:arc4random_uniform(MAX_ROOMCOUNT) + 1];
    
    for (int i = 0; i < arc4random_uniform(10) + 1; i++) {
        //Comment
        Comment *commentToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
        commentToAdd.comment = [self generateRandomStringWithLength:[self generateRandomLength:COMMENT_MIN_LENGTH]];
        commentToAdd.date = [NSDate date];
        
        //User
        User *userToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        userToAdd.userName = [self generateRandomStringWithLength:[self generateRandomLength:USERNAME_MIN_LENGTH]];
        userToAdd.firstName = [self generateRandomStringWithLength:[self generateRandomLength:FIRSTNAME_MIN_LENGTH]];
        userToAdd.lastName = [self generateRandomStringWithLength:[self generateRandomLength:LASTNAME_MIN_LENGTH]];
        userToAdd.address = [self generateRandomStringWithLength:[self generateRandomLength:ADDRESS_MIN_LENGTH]];
        userToAdd.age = [NSNumber numberWithInt:arc4random_uniform(MAX_AGE) + 1];
        
        commentToAdd.author = userToAdd;
        [apartmentToAdd addCommentsObject:commentToAdd];
    }
}

-(void)updateDatabase
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apartment"];
    request.sortDescriptors = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    Apartment *randomApartment = nil;
    
    do {
        
        randomApartment = (Apartment *)matches[arc4random_uniform([matches count])];
        
    } while (randomApartment == self.currentApartment);
    
    randomApartment.name = [self generateRandomStringWithLength:[self generateRandomLength:NAME_MIN_LENGTH]];
    randomApartment.location = [self generateRandomStringWithLength:[self generateRandomLength:LOCATION_MIN_LENGTH]];
    randomApartment.detailInfo = [self generateRandomStringWithLength:[self generateRandomLength:DETAILS_MIN_LENGTH]];
    randomApartment.price = [NSNumber numberWithInt:arc4random_uniform(MAX_PRICE) + 1];
    randomApartment.roomsCount = [NSNumber numberWithInt:arc4random_uniform(MAX_ROOMCOUNT) + 1];
    
    [self.managedObjectContext save:nil];
    [self addRandomApartment];
    [self.managedObjectContext save:nil];
    
    do {
        randomApartment = (Apartment *)matches[arc4random_uniform([matches count])];
    } while (randomApartment == self.currentApartment);
    
    [self.managedObjectContext deleteObject:randomApartment];
    [self.managedObjectContext save:nil];
}


@end
