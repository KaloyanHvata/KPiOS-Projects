//
//  SearchViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController() <UITextFieldDelegate>


@property (nonatomic,strong)IBOutlet UITextField *minRoomsTextField;
@property (nonatomic,strong)IBOutlet UITextField *maxRoomsTextField;
@property (nonatomic,strong)IBOutlet UITextField *minPriceTextField;
@property (nonatomic,strong)IBOutlet UITextField *maxPriceTextField;
@property (nonatomic, strong)IBOutlet UITextField *locationTextField;

@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - IBActions


- (IBAction)search:(UIButton *)sender
{
    [self.delegate searchButtonPressedWithMinRoomsCount:[self.minRoomsTextField.text intValue] maxRoomsCount:[self.maxRoomsTextField.text intValue] andPriceFrom:[self.minPriceTextField.text intValue] toPrice:[self.maxPriceTextField.text intValue] andLocation:self.locationTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
