//
//  DetailViewController.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/29/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController() <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailWebView.delegate = self;
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.webURL];
    [self.detailWebView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

@end
