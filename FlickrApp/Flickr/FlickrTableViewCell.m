//
//  FlickrTableViewCell.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/27/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "FlickrTableViewCell.h"
#import "Author.h"

@interface FlickrTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *flickrImageView;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FlickrTableViewCell

- (void)setImage:(Image *)image
{
    _image = image;
    
    self.flickrImageView.backgroundColor = [UIColor darkGrayColor];
    
    [self startDownloadingImage];
    
    Author *author = image.author;
    self.authorImageView.image = [UIImage imageWithData:author.authorImage];
    
    [self prepareAuthorImageView];
    
    self.authorNameLabel.text = author.name;
    self.imageTitleLabel.text = image.title;
    //self.timeLabel.backgroundColor = [UIColor whiteColor];
    self.timeLabel.text = [self timeElapsed:image.dateUpdated];
}

- (void)startDownloadingImage{
    //Method for downloading the Image
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.image.imageURL]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        //Checking for error
        if (!error) {
            if ([request.URL isEqual:[NSURL URLWithString:self.image.imageURL]]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                //New Thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    CGFloat width = [UIScreen mainScreen].bounds.size.width;
                    self.flickrImageView.frame = CGRectMake(0, 0, width, width * [self.image.ratio doubleValue]);
                    self.flickrImageView.image = image;
                });
            }
        }
    }];
    [task resume];
}


#pragma mark - Helper methods

- (void)prepareAuthorImageView{
    //Helper method that prepares the image of the author
    self.authorImageView.layer.cornerRadius = self.authorImageView.frame.size.height /4;
    self.authorImageView.layer.masksToBounds = YES;
    self.authorImageView.layer.borderWidth = 0;
}
- (void)prepareForReuse{
    //Method that clears the content and prepares for reuse
    [super prepareForReuse];
    
    self.flickrImageView.image = nil;
    self.authorImageView.image = nil;
}

- (NSString *)timeElapsed:(NSDate *)date {
    //Helper method for calculating the elapsed time from the event
    NSString *timeElapsed;
    //Seting up the date format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH-mm-ss"];
    NSDate *currentDate = [NSDate date];
    NSInteger seconds = [currentDate timeIntervalSinceDate:date];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        timeElapsed = [NSString stringWithFormat:@"%ldd", (long)days];
        //NSLog(@"%ld",(long)days);
    }
    else if(hours) { timeElapsed = [NSString stringWithFormat: @"%ldh", (long)hours];
         //NSLog(@"%ld",(long)hours);
    }
    else if(minutes) { timeElapsed = [NSString stringWithFormat: @"%ldm", (long)minutes];
        // NSLog(@"%ld",(long)minutes);
    }
    else if(seconds)
        timeElapsed = [NSString stringWithFormat: @"%lds", (long)seconds];
         //NSLog(@"%ld",(long)seconds);
    return timeElapsed;
}

@end
