//
//  POOContactInfoViewController.h
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 25.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POOContactInfoViewController : UIViewController

- (POOContactInfoViewController *)initWithName:(NSString *)name lastName:(NSString *)lastName phones:(NSDictionary *)phones;

@end
