//
//  Event.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype) initWithTitle:(NSString*) eventTitle withImage:(NSString*) image withDescription:(NSString*) eventDescription withRelatedPerson: (NSString*) relatedPerson withDuration:(NSString*) duration{

    self = [super init];
    if(self){
        _eventTitle = eventTitle;
        _image = [UIImage imageNamed:image];
        _eventDescription = eventDescription;
        _relatedPerson = relatedPerson;
        _duration = duration;
    }
    return self;
}
-(void) encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.eventTitle forKey:@"eventTitle"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:@"eventImage"];
    [aCoder encodeObject:self.eventDescription forKey:@"eventDescription"];
    [aCoder encodeObject:self.relatedPerson forKey:@"eventRelatedPerson"];
    [aCoder encodeObject:self.duration forKey:@"eventDuration"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        self.eventTitle = [aDecoder decodeObjectForKey:@"eventTitle"];
        self.image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"eventImage"]];
        self.eventDescription = [aDecoder decodeObjectForKey:@"eventDescription"];
        self.relatedPerson = [aDecoder decodeObjectForKey:@"eventRelatedPerson"];
        self.duration = [aDecoder decodeObjectForKey:@"eventDuration"];
    }
    return  self;
}

@end
