//
//  DetailedViewController.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "DetailedViewController.h"
#import "Singleton.h"

@interface DetailedViewController ()
@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *relatedPersonLabel;
@property (strong, nonatomic) UILabel *eventDate;
@property (strong, nonatomic) UITextView *eventDescriptionTextView;
@property (strong, nonatomic) UIImageView *eventImageView;

@end

@implementation DetailedViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(Delete)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    id<UILayoutSupport>guide = self.topLayoutGuide;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.relatedPersonLabel = [[UILabel alloc] init];
    self.relatedPersonLabel.font = [UIFont systemFontOfSize:18.0f];
    
    self.eventDate = [[UILabel alloc] init];
    self.eventDate.font = [UIFont italicSystemFontOfSize:16.0f];
    
    self.eventImageView = [[UIImageView alloc] init];
    self.eventImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.eventImageView.layer.borderWidth = 5.0f;
    self.eventImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.eventImageView.layer.shadowRadius = 4.0f;
    self.eventImageView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.eventImageView.layer.shadowOpacity = 0.5f;
 

   
    self.eventImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.eventImageView.layer.shouldRasterize = YES;
    
    
    self.eventDescriptionTextView = [[UITextView alloc] init];
    self.eventDescriptionTextView.textAlignment = NSTextAlignmentJustified;
    self.eventDescriptionTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.eventDescriptionTextView.editable = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE-dd-MMM"];
    
    self.titleLabel.text = self.event.eventTitle;
    self.relatedPersonLabel.text = self.event.relatedPerson;
    self.eventDate.text = [formatter stringFromDate:self.date];
    self.eventImageView.image = self.event.image;
    self.eventDescriptionTextView.text = self.event.eventDescription;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.relatedPersonLabel];
    [self.view addSubview:self.eventDate];
    [self.view addSubview:self.eventImageView];
    [self.view addSubview:self.eventDescriptionTextView];
    
    
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.relatedPersonLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.eventDate setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.eventImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.eventDescriptionTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[_titleLabel]-[_eventDate]-[_eventImageView]-10-[_eventDescriptionTextView(>=44)]-10-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_titleLabel, _eventDate, _eventImageView, _eventDescriptionTextView)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[guide]-20-[_titleLabel]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_titleLabel, guide)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"[_titleLabel]-30-[_relatedPersonLabel]"
                               options:NSLayoutFormatAlignAllTop
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_titleLabel, _relatedPersonLabel)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.relatedPersonLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.eventDate
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:130]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.eventImageView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.eventImageView
                              attribute:NSLayoutAttributeHeight
                              multiplier:self.eventImageView.image.size.width / self.eventImageView.image.size
                              .height
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.eventImageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[_eventDescriptionTextView]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_eventDescriptionTextView)]];
    
}

- (void)Delete
{
        Singleton *eventBook = [Singleton eventsBook];
        [eventBook removeEvent:self.event fromDate:self.date];
        [eventBook writeDataTofile];
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done!"message:@"You have successfully deleted the event!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    
}
@end
