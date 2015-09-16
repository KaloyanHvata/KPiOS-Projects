//
//  HeaderCollectionReusableView.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation HeaderCollectionReusableView

- (void)setDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE-dd-MMM"];
    NSString *stringDate = [formatter stringFromDate:date];
    self.dateLabel.text = stringDate;
}

@end
