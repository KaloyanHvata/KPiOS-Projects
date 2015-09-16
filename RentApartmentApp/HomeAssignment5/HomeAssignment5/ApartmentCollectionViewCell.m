//
//  ApartmentCollectionViewCell.m
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import "ApartmentCollectionViewCell.h"

@interface ApartmentCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *apartmentImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation ApartmentCollectionViewCell

- (void)setApartment:(Apartment *)apartment
{
    _apartment = apartment;
    self.apartmentImageView.image = [UIImage imageWithData:self.apartment.image];
    self.roomsCountLabel.text = [NSString stringWithFormat:@"%ld",
                                [self.apartment.roomsCount integerValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"EUR%ld", [self.apartment.price integerValue]];
    self.addressLabel.text = self.apartment.location;
}

@end
