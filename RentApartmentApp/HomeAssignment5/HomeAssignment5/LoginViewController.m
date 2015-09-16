//
//  LoginViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"
#import "ApartmentsCollectionVIewController.h"
#import "User.h"

@interface LoginViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentuser = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - KeyboardNotifications


- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
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

- (IBAction)loginButton:(UIButton *)sender
{
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length]) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        request.predicate = [NSPredicate predicateWithFormat:@"userName = %@", self.usernameTextField.text];
        request.sortDescriptors = nil;
        
        NSArray* matches = [context executeFetchRequest:request error:nil];
        
        if (matches.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed!" message:@"Wrong username!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try again!" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else if ( ![[(User *)[matches firstObject] password] isEqualToString:self.passwordTextField.text] ) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed!" message:@"Wrong password!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try again!" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            appDelegate.currentuser = (User *)[matches firstObject];
            UINavigationController *acvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApartmentsNC"];
            [self presentViewController:acvc animated:YES completion:nil];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Both username and password fields should be filled in!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)signinButton:(UIButton *)sender
{
    SignInViewController *sivc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self presentViewController:sivc animated:YES completion:nil];
}



@end
