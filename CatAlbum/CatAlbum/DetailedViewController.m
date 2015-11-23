//
//  DetailedViewController.m
//  CatAlbum
//
//  Created by Kaloyan Petrov on 10/6/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "DetailedViewController.h"

@interface DetailedViewController ()
@property (weak, nonatomic)IBOutlet UIImageView *imageView;
@property (weak, nonatomic)IBOutlet UILabel *label;
@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageView setImage:self.image];
    self.label.text = self.name;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
