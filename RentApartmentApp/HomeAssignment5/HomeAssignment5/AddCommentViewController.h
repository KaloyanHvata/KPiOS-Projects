//
//  AddCommentViewController.h
//  HomeAssignment5
//
//  Created by Kaloyan Petrov on 5/16/15.
//  Copyright (c) 2015 Kaloyan Petrov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCommentProtocol <NSObject>

- (void)addNewCommentWithText:(NSString *)text;

@end

@interface AddCommentViewController : UIViewController

@property (nonatomic, weak) id<AddCommentProtocol> delegate;

@end
