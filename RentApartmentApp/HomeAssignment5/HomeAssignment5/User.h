//
//  User.h
//  
//
//  Created by Kaloyan Petrov on 5/16/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *comments;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
