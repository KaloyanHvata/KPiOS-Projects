//
//  SignInViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "SignInViewController.h"
#import "User+Validate.h"
#import "AppDelegate.h"
#import "ApartmentsCollectionVIewController.h"

@interface SignInViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordtTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@end

@implementation SignInViewController

- (void)viewDidLoad
{
    self.usernameTextField.delegate = self;
    self.passwordtTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    self.firstNameTextField.delegate = self;
    self.secondNameTextField.delegate = self;
    self.ageTextField.delegate = self;
    self.addressTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.ageTextField) {
        if (![self validateAge]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incorrect Age!" message:@"Type only digits in the Age field" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            self.ageTextField.text = @"";
        }
    } else if (textField == self.repeatPasswordTextField) {
        if (![self passwordMatch]) {
            self.repeatPasswordTextField.text = @"";
        }
    }
}

#pragma mark - IBActions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(UIBarButtonItem *)sender
{
    if ([self validateInput]) {
        if ([User checkForExistingUsername:self.usernameTextField.text]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration error!" message:@"User with such username already exists!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = appDelegate.managedObjectContext;
            User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            
            newUser.userName = self.usernameTextField.text;
            newUser.firstName = self.firstNameTextField.text;
            newUser.lastName = self.secondNameTextField.text;
            newUser.age = [NSNumber numberWithInt:[self.ageTextField.text intValue]];
            newUser.address = self.addressTextField.text;
            newUser.password = self.passwordtTextField.text;
            
            NSError *error = nil;
            [context save:&error];
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the database. User was not created!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                appDelegate.currentuser = newUser;
                UINavigationController *acvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApartmentsNC"];
                [self presentViewController:acvc animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - Helper methods

- (BOOL)validateAge //checks if Age TextField contains only digits
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.ageTextField.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}


- (BOOL)passwordMatch //checks if the reapeat password matches
{
    if ([self.passwordtTextField.text isEqualToString:self.repeatPasswordTextField.text]) {
        return YES;
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Erorr!" message:@"Type correctly both password fields!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
}


- (BOOL)validateInput //checks if all fields are filled in
{
    if ([self.usernameTextField.text length] && [self.passwordtTextField.text length] && [self.repeatPasswordTextField.text length] && [self.firstNameTextField.text length] && [self.secondNameTextField.text length] && [self.ageTextField.text length] && [self.addressTextField.text length]) {
        return YES;
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"All fields are required! Please fill every field with correct information." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
}

@end
