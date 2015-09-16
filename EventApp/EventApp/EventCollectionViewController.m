//
//  EventCollectionViewController.m
//  EventApp
//
//  Created by AdrenalineHvata on 4/28/15.
//  Copyright (c) 2015 MentorMateAcademy. All rights reserved.
//
#import "EventCollectionViewController.h"
#import "EventCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "Singleton.h"
#import "DetailedViewController.h"

@interface EventCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *rotations;
@property (nonatomic, strong) Singleton *eventBook;
@property (nonatomic) NSInteger cellWidth;
@property (nonatomic) NSInteger currentColumnsCount;
@end

static NSString * const eventCellIdentifier = @"EventCell";
static NSString * const reusableViewIdentifier = @"HeaderView";

@implementation EventCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventBook = [Singleton eventsBook];
    
    UIImage *patternImage = [UIImage imageNamed:@"grass"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.currentColumnsCount = 2;
    self.cellWidth = [self calculateCellWidthForColumnNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self.collectionView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionViewLayout invalidateLayout];
    self.cellWidth = [self calculateCellWidthForColumnNumber];
    [self.collectionView reloadData];
}

#pragma mark - IBActions

- (IBAction)layoutTwoColumns:(UIBarButtonItem *)sender
{
    self.currentColumnsCount = 2;
    self.cellWidth = [self calculateCellWidthForColumnNumber];
    [self.collectionView reloadData];
}

- (IBAction)layoutThreeColumns:(UIBarButtonItem *)sender
{
    self.currentColumnsCount = 3;
    self.cellWidth = [self calculateCellWidthForColumnNumber];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, self.cellWidth * 1.2);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[DetailedViewController class]]) {
            DetailedViewController *devc = (DetailedViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
            NSDate *date = self.eventBook.dates[indexPath.section];
            devc.date = date;
            NSArray *eventsForDate = [self.eventBook.events objectForKey:date];
            Event *event = eventsForDate[indexPath.row];
            devc.event = event;
        }
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.eventBook.dates count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDate *date = self.eventBook.dates[section];
    NSArray *eventsForDate = [self.eventBook.events objectForKey:date];
    return [eventsForDate count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:eventCellIdentifier forIndexPath:indexPath];
    
    NSDate *date = self.eventBook.dates[indexPath.section];
    NSArray *eventsForDate = [self.eventBook.events objectForKey:date];
    Event *event = eventsForDate[indexPath.row];
    
    cell.event = event;
    
    [self setupCell:cell];
    cell.transform = CGAffineTransformMakeRotation([self.rotations[indexPath.row] floatValue]);
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewIdentifier forIndexPath:indexPath];
    
    NSDate *date = self.eventBook.dates[indexPath.section];
    view.date = date;
    
    return view;
}

#pragma mark - Helper methods

- (void)setupCell:(EventCollectionViewCell *)cell
{
    cell.layer.masksToBounds = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    cell.layer.shadowOpacity = 0.5f;
    
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;
}

- (NSInteger)calculateCellWidthForColumnNumber
{
    NSInteger cellWidth;
    
    NSInteger screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    NSInteger usableScreenWidth = screenWidth - 35 - ((self.currentColumnsCount - 1) * 15);
    
    cellWidth = usableScreenWidth / self.currentColumnsCount;
    
    return cellWidth;
}

@end
