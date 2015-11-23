//
//  CatAlbumCollectionViewController.m
//  CatAlbum
//
//  Created by Kaloyan Petrov on 10/6/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "CatAlbumCollectionViewController.h"
#import "CatsCollectionViewCell.h"
#import "DetailedViewController.h"

@interface CatAlbumCollectionViewController ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *catNames;
@property (nonatomic, strong) NSMutableArray *catImages;
@property (nonatomic, strong) NSMutableDictionary *propertyListResults;
@property (nonatomic, strong) CatsCollectionViewCell *cell;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
//Filter Backup Arrays
@property (nonatomic, strong) NSMutableArray *allCatImages;
@property (nonatomic, strong) NSMutableArray *allCatNames;
//Buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *whiteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *blackButton;

//To keep the selected and deselected paths
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation CatAlbumCollectionViewController

static NSString * const cellIdentifier = @"CatCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.whiteButton setEnabled:NO];
    [self.blackButton setEnabled:NO];
    //Setting up an activity indicator for better UX
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = [UIColor blackColor];
    [self.spinner setCenter:[self.view center]];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

    //Cosmetic changes to look more like the example
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //Setting up the Networking
    self.catNames = [[NSMutableArray alloc]init];
    self.catImages = [[NSMutableArray alloc]init];
    self.allCatNames = [[NSMutableArray alloc]init];
    self.allCatImages = [[NSMutableArray alloc]init];

    dispatch_queue_t fetchQ = dispatch_queue_create("cats fetcher", NULL);
            dispatch_async(fetchQ, ^{
                
                self.url = [NSURL URLWithString:@"http://pinkytown.com/cats/"];
                NSData *jsonResults = [NSData dataWithContentsOfURL:self.url];
                self.propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
                self.catNames = [self.propertyListResults valueForKeyPath:@"name"];
                self.allCatNames = [self.propertyListResults valueForKeyPath:@"name"];
                
                for (int i = 0; i < self.catNames.count; i++) {
                    NSURL *bUrl = [self.url URLByAppendingPathComponent:[self.catNames objectAtIndex:i]];
                    //Lazy Check
                    NSString *checkString = [NSString stringWithFormat:@"%@",bUrl];
                    if(![checkString containsString:@".php"]){
                    NSData * data = [NSData dataWithContentsOfURL:bUrl];
                    UIImage *resultImage = [UIImage imageWithData:data];
                    [self.catImages addObject:resultImage];
                     [self.allCatImages addObject:resultImage];
                    }
        
                }
              
                NSLog(@"Flickr results = %@ + %@", self.catNames,self.catImages);
    
      dispatch_async(dispatch_get_main_queue(), ^{
                    [self.spinner stopAnimating];
                    [self.collectionView reloadData];
                    [self.whiteButton setEnabled:YES];
                    [self.blackButton setEnabled:YES];
      });
    });
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
   //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.collectionView reloadData];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.catImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CatsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *cellName = [self.catNames objectAtIndex:indexPath.row];
  
    // Configure the cell
    [cell.imageView setImage:[self.catImages objectAtIndex:indexPath.row]];
    
    [cell.nameLabel setText:cellName];
    
    return cell;
}


#pragma mart <Navigation>
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[DetailedViewController class]]) {
            DetailedViewController *devc = (DetailedViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
            //If we use fetchresult controller we have to use indexPath.section
            UIImage *image = self.catImages[indexPath.row];
            NSString *name = self.catNames[indexPath.row];
            devc.image = image;
            devc.name = name;
         
        }
    }
}
- (IBAction)whiteFilterButtonPressed:(id)sender {

    self.catImages = self.allCatImages;
    self.catNames = self.allCatNames;
    NSMutableArray *whiteArrNames = [[NSMutableArray alloc]init];
    NSMutableArray *whiteArrPics = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.catImages.count; i++) {
        if ([[self.catNames objectAtIndex:i] containsString:@"white"]) {
            [whiteArrNames addObject:[self.catNames objectAtIndex:i]];
             [whiteArrPics addObject:[self.catImages objectAtIndex:i]];
           
        }
    }
    
    self.catImages = whiteArrPics;
    self.catNames = whiteArrNames;
    NSLog(@"%@+%@",self.catImages,self.catNames);
    [self.collectionView reloadData];
   

}

- (IBAction)blackFilterButtonPressed:(id)sender {
    
    self.catImages = self.allCatImages;
    self.catNames = self.allCatNames;
    NSMutableArray *whiteArrNames = [[NSMutableArray alloc]init];
    NSMutableArray *whiteArrPics = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.catImages.count; i++) {
        if (![[self.catNames objectAtIndex:i] containsString:@"white"]) {
            [whiteArrNames addObject:[self.catNames objectAtIndex:i]];
            [whiteArrPics addObject:[self.catImages objectAtIndex:i]];
            
        }
    }
    
    self.catImages = whiteArrPics;
    self.catNames = whiteArrNames;
    NSLog(@"%@+%@",self.catImages,self.catNames);
    [self.collectionView reloadData];

}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // always reload the selected cell, so we will add the border to that cell
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
