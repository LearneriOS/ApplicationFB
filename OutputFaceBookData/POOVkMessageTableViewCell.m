//
//  POOVkMessageTableViewCell.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 17.03.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "POOVkMessageTableViewCell.h"
#import "String+Md5.h"
#import "POOCache.h"

@interface POOVkMessageTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *interlocutorImage;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *interlocutorNameAndSecondname;
@property (strong, nonatomic) IBOutlet UIImageView *interlocutorStatus;
@property (strong, nonatomic) IBOutlet UILabel *message;

@end

@implementation POOVkMessageTableViewCell

+ (instancetype) cell {
    return  [[[[self class] cellNib]instantiateWithOwner:nil options:nil] firstObject];
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[[self class] identifier] bundle:nil];
}

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (void)initWithInterlocutorImage:(NSString *)interlocutorImage interlocutorNameAndSecondname:(NSString *)interlocutorNameAndSecondname message:(NSString *)message online:(NSInteger)online outbox:(BOOL)outbox readFlag:(BOOL)readFlag {

    NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
    [self loadAndSetMyImageFromURL:[userDefult objectForKey:@"user_photo_100"]];
    [self loadAndSetInterlocutorImageFromURL:interlocutorImage];
    
    self.interlocutorNameAndSecondname.text = interlocutorNameAndSecondname;
    self.message.text = message;

    [self outSetting:outbox read:readFlag];
    [self onlineSetting:online];
    [self readFlagSetting:readFlag];
}

- (void)outSetting:(BOOL)outbox read:(BOOL)read {
    if(outbox) {
        self.myImage.hidden = NO;
        //[self readFlagSettingOut:read];
    } else {
        self.myImage.hidden = YES;
        //[self readFlagSetting:read];
    }
}

- (void)readFlagSetting:(BOOL)readFlag {
    if(!readFlag) {
        UIColor *myColor = [UIColor colorWithRed: 0.0/255.0 green: 130.0/255.0 blue:255.0/255.0 alpha: 0.4];
        self.backgroundColor = myColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)readFlagSettingOut:(BOOL)readFlag {
    if(!readFlag) {
        UIColor *myColor = [UIColor colorWithRed: 0.0/255.0 green: 130.0/255.0 blue:255.0/255.0 alpha: 0.4];
        self.message.backgroundColor = myColor;
    } else {
        self.message.backgroundColor = [UIColor whiteColor];
    }
}

- (void)onlineSetting:(BOOL)online {
    if (online == 1) {
        self.interlocutorStatus.hidden = NO;
        self.interlocutorStatus.image = [UIImage imageNamed:@"Online"];
    } else {
        self.interlocutorStatus.hidden = YES;
    }
}

- (void) loadAndSetInterlocutorImageFromURL:(NSString *)URL {
    [self.interlocutorImage sd_setImageWithURL:[NSURL URLWithString:URL]];
}

- (void) loadAndSetMyImageFromURL:(NSString *)URL {
    [self.myImage sd_setImageWithURL:[NSURL URLWithString:URL]];
}

- (void) updateConstraints {
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
