//
//  CommentsTableViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "Comment.h"
#import "AddCommentViewController.h"
#import "AppDelegate.h"
#import "CommentTableViewCell.h"

#define CELL_HEIGHT 190

@interface CommentsTableViewController() <AddCommentProtocol>

@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) UIBarButtonItem *addComment;

@end

@implementation CommentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Comments";
    
    self.addComment = [[UIBarButtonItem alloc] initWithTitle:@"Add comment" style:UIBarButtonItemStylePlain target:self action:@selector(addNewComment)];
    self.navigationItem.rightBarButtonItem = self.addComment;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.apartment.comments allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    self.commentsArray = [self.apartment.comments allObjects];
    Comment *comment = self.commentsArray[indexPath.row];
    cell.comment = comment;
    
    return cell;
}

#pragma mark - IBActions

- (void)addNewComment
{
    AddCommentViewController *acvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddComment"];
    acvc.delegate = self;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:acvc];
    popover.popoverContentSize = CGSizeMake(350, 400);
    [popover presentPopoverFromBarButtonItem:self.addComment permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


#pragma mark - AddCommentProtocol

- (void)addNewCommentWithText:(NSString *)text
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    Comment *commentToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
    commentToAdd.comment = text;
    commentToAdd.date = [NSDate date];
    commentToAdd.author = appDelegate.currentuser;
    commentToAdd.apartment = appDelegate.currentApartment;
    
    NSError *error = nil;
    [context save:&error];
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the database. Apartment was not added!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView reloadData];
}

@end
