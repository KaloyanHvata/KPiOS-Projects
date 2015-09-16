//
//  CommentTableViewCell.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "User.h"

@interface CommentTableViewCell()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    self.commentTextView.text = self.comment.comment;
    self.usernameLabel.text = self.comment.author.userName;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSString *date = [formatter stringFromDate:self.comment.date];
    self.dateAddedLabel.text = date;
}

@end
