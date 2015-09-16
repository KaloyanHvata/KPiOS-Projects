//
//  DetailViewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentsTableViewController.h"

@interface DetailViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *roomsTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *perNightLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomsLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageWithData:self.apartment.image];
    self.locationTextField.text = self.apartment.location;
    self.roomsTextField.text = [NSString stringWithFormat:@"%d", [self.apartment.roomsCount integerValue]];
    self.priceTextField.text = [NSString stringWithFormat:@"EUR%d", [self.apartment.price integerValue]];
    self.nameTextField.text = self.apartment.name;
    self.detailTextField.text = self.apartment.detailInfo;
    
    if ([UIImagePNGRepresentation(self.imageView.image) isEqualToData:UIImagePNGRepresentation([UIImage imageNamed:@"no-image"])]) { //if image is defauls make all labels white
        UIColor *white = [UIColor whiteColor];
        self.locationTextField.textColor = white;
        self.roomsTextField.textColor = white;
        self.priceTextField.textColor = white;
        self.roomsLabel.textColor = white;
        self.perNightLabel.textColor = white;
    }
    
    UIBarButtonItem *comments = [[UIBarButtonItem alloc] initWithTitle:@"Comments" style:UIBarButtonItemStylePlain target:self action:@selector(comments:)];
    self.navigationItem.rightBarButtonItem = comments;
}

#pragma mark - IBActions

- (void)comments:(UIBarButtonItem *)button
{
    CommentsTableViewController *ctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Comments"];
    ctvc.apartment = self.apartment;
    [self.navigationController pushViewController:ctvc animated:YES];
}

@end
