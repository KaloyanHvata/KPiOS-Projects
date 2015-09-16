//
//  FlickrTableViewController.m
//  Flickr
//
//  Created by AdrenalineHvata on 5/27/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "XMLDictionary.h"
#import "FlickrTableViewCell.h"
#import <CoreData/CoreData.h>
#import "Image+Create.h"
#import "AppDelegate.h"
#import "FlickrManager.h"
#import "DetailViewController.h"

@interface FlickrTableViewController() <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation FlickrTableViewController

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [self alert];
        //NSLog(@"Error with the fetching");
    }
    //Refresh Control setup
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshFeed)
                  forControlEvents:UIControlEventValueChanged];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //No use of navigation bar in this view controller
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRefreshControl) name:@"RefreshingFeedDidEndNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshingFeedDidEndNotification" object:nil];
}
#pragma mark - Helper methods

- (void)alert{
    //Infroms the user if there is a problem with the feed
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"There was a problem. Fetching data could not be performed!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Setters

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
    //set a proper batch size
    request.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datePublished" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Selectors

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)refreshFeed{
    //Using singleton method to refresh the feed
    FlickrManager *manager = [FlickrManager manager];
    [manager fetchNewEntriesFromFlickrFeed];
}

- (void)hideRefreshControl{
    [self.refreshControl endRefreshing];
}
#pragma mark - NSFetchResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller{
    
    [self.tableView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Dynamic resizing
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    Image *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return width * [image.ratio doubleValue] + ADDITIONAL_HEIGHT;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FlickrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlickrCell" forIndexPath:indexPath];
    
    Image *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.image = image;
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        //Thought of making another segue for going in the author's profile through his profile picture, but since the web view holds the pictures it wasn't necessary
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Image *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
            DetailViewController *dvc = (DetailViewController *)segue.destinationViewController;
            dvc.webURL = [NSURL URLWithString:image.flickrURL];
        }
    }
}


@end
