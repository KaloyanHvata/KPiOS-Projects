//
//  Event.h
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Event : NSObject<NSCoding>
@property (strong,nonatomic) NSString *eventTitle;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *eventDescription;
@property (strong,nonatomic) NSString *relatedPerson;
@property (strong,nonatomic) NSString *duration;


-(instancetype) initWithTitle:(NSString*) eventTitle withImage:(NSString*) image withDescription:(NSString*) eventDescription withRelatedPerson: (NSString*) relatedPerson withDuration:(NSString*) duration;
                                                                                                                                        
@end
