//
//  AddCommentViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@end

@implementation AddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //setup textview's borders
    [[self.commentTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.commentTextView layer] setBorderWidth:0.6];
    [[self.commentTextView layer] setCornerRadius:10];

}

#pragma mark - IBActions

- (IBAction)addComment:(UIButton *)sender
{
    if ([self.commentTextView.text length]) {
        [self.delegate addNewCommentWithText:self.commentTextView.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
