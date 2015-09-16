//
//  ApartmentsCollectionVIewController.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "ApartmentsCollectionVIewController.h"
#import "ApartmentCollectionViewCell.h"
#import "AppDelegate.h"
#import "AddApartmentViewContoller.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"

@interface ApartmentsCollectionVIewController() <NSFetchedResultsControllerDelegate, NSFetchedResultsControllerDelegate, SearchDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPredicate *predicate;
@end

static NSString *cellIdentifier = @"ApartmentCell";

@implementation ApartmentsCollectionVIewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [self alert];
    }
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItems = @[self.searchBarButton, logout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentApartment = nil;
}

#pragma mark - Setters

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apartment"];
    request.fetchBatchSize = 15;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"roomsCount" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = self.predicate;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - SearchDelegate

- (void)searchButtonPressedWithMinRoomsCount:(int)minRooms maxRoomsCount:(int)maxRooms andPriceFrom:(int)minPrice toPrice:(int)maxPrice andLocation:(NSString *)location
{
    NSMutableArray* predicates = [NSMutableArray array];
    
    [predicates addObject:[NSPredicate predicateWithFormat:@"roomsCount >= %d", minRooms]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"roomsCount <= %d", maxRooms]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"price >= %d", minPrice]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"price <= %d", maxPrice]];
    if ([location length] != 0) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"location CONTAINS[c] %@", location]];
    }
    
    self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    _fetchedResultsController = nil;
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [self alert];
    }
    
    [self.collectionView reloadData];
}
#pragma mark - IBActions

- (IBAction)addNewApartmentButton:(UIBarButtonItem *)sender
{
    AddApartmentViewContoller *aavc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddApartment"];
    [self presentViewController:aavc animated:YES completion:nil];
}

- (void)logout
{
    LoginViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:lvc animated:NO completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have been successfully logged out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApartmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Apartment *apartment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.apartment = apartment;
    
    return cell;
}

#pragma mark - NSFetchResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeMove: {
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Apartment *apartment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            DetailViewController *dvc = (DetailViewController *)segue.destinationViewController;
            dvc.apartment = apartment;
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.currentApartment = apartment;
        }
    } else if ([segue.identifier isEqualToString:@"Search"]) {
        if ([segue.destinationViewController isKindOfClass:[SearchViewController class]]) {
            SearchViewController *svc = (SearchViewController *)segue.destinationViewController;
            svc.delegate = self;
        }
    }
}

#pragma mark - Helper methods

- (void)alert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the database. Fetch could not be performed!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
