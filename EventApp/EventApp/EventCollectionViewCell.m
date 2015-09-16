//
//  EventCollectionViewCell.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "EventCollectionViewCell.h"

@interface EventCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@end

@implementation EventCollectionViewCell

- (void)setEvent:(Event *)event
{
    self.titleLabel.text = event.eventTitle;
    self.relatedPersonLabel.text = event.relatedPerson;
    self.durationLabel.text = event.duration;
    self.descriptionLabel.text = event.eventDescription;
    self.eventImageView.image = event.image;
}

@end

