//
//  POOVkMessageTableViewCell.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 17.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POOVkMessageTableViewCell : UITableViewCell

- (void)initWithInterlocutorImage:(NSString *)interlocutorImage interlocutorNameAndSecondname:(NSString *)interlocutorNameAndSecondname message:(NSString *)message online:(NSInteger)online outbox:(BOOL)outbox readFlag:(BOOL)readFlag;

@end
