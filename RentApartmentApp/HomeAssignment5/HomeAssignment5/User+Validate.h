//
//  User+Validate.h
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "User.h"

@interface User (Validate)

+ (BOOL)checkForExistingUsername:(NSString *)username;

@end
