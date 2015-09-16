//
//  AddApartmentViewContoller.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "AddApartmentViewContoller.h"
#import "AppDelegate.h"
#import "Apartment.h"

@interface AddApartmentViewContoller() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomsTextField;

@end

@implementation AddApartmentViewContoller

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.locationTextField.delegate = self;
    
    //setup TextView with borders
    [[self.detailsTextView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.detailsTextView layer] setBorderWidth:0.6];
    [[self.detailsTextView layer] setCornerRadius:10];
}

#pragma mark - IBActions

- (IBAction)cancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addApartment:(UIBarButtonItem *)sender
{
    if ([self validateInput]) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSNumber *price = @([self.priceTextField.text floatValue]);
        NSNumber *rooms = @([self.roomsTextField.text floatValue]);
        Apartment *newApartment = [NSEntityDescription insertNewObjectForEntityForName:@"Apartment" inManagedObjectContext:context];
        newApartment.name = self.nameTextField.text;
        newApartment.location = self.locationTextField.text;
        newApartment.detailInfo = self.detailsTextView.text;
        newApartment.price = price;
        newApartment.roomsCount = rooms;
        newApartment.image = UIImagePNGRepresentation(self.imageView.image);
        
        NSError *error = nil;
        [context save:&error];
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the database. Apartment was not added!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"New apartment was successfully added!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            UINavigationController *acvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApartmentsNC"];
            [self presentViewController:acvc animated:YES completion:nil];
        }
    }
}

- (IBAction)pickImage:(UIButton *)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo {
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper methods


- (BOOL)validateInput //validate if all fields are filled in
{
    if ([self.nameTextField.text length] && [self.locationTextField.text length] && [self.priceTextField.text length] && [self.roomsTextField.text length] && [self.detailsTextView.text length]) {
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
