//
//  CatsCollectionViewCell.h
//  CatAlbum
//
//  Created by Kaloyan Petrov on 10/6/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatsCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
