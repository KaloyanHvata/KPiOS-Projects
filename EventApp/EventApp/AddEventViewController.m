//
//  AddEventViewController.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/29/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "AddEventViewController.h"
#import "Singleton.h"
#import "Event.h"

@interface AddEventViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextView *notesTextField;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *relatedPersonTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) Singleton *eventBook;

@property (nonatomic, assign, getter = isDateOpen) BOOL dateOpen;
@property (nonatomic, assign, getter = isDurationOpen) BOOL durationOpen;
@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventBook = [Singleton eventsBook];
    
    self.notesTextField.delegate = self;
    self.titleTextField.delegate = self;
    self.relatedPersonTextField.delegate = self;
    
    self.notesTextField.text = @"Add description...";
    self.notesTextField.textColor = [UIColor lightGrayColor];
    
    self.durationTextField.text = @"0h 0m";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE-dd-MMM"];
    self.dateLabel.text = [formatter stringFromDate:[NSDate date]];
    
    self.addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.addButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)add
{
    Event *event = [[Event alloc] init];
    event.eventTitle = self.titleTextField.text;
    event.relatedPerson = self.relatedPersonTextField.text;
    event.duration = self.durationTextField.text;
    event.eventDescription = self.notesTextField.text;
    event.image = [UIImage imageNamed:@"forest"];
    
    [self.eventBook addEvent:event forDate:self.datePicker.date ? self.datePicker.date : [NSDate date]];
    
    Singleton *singleton = [Singleton eventsBook];
    [singleton writeDataTofile];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Add Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add Description";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.titleTextField) {
        if ([textField.text length]) {
            self.addButton.enabled = YES;
        } else {
            self.addButton.enabled = NO;
        }
    }
}

#pragma mark - IBActions

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE-dd-MMM"];
    self.dateLabel.text = [formatter stringFromDate:picker.date];
}


@end
