//
//  POOContactInfoViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 25.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import "POOContactInfoViewController.h"

static NSInteger INDENT = 20;

@interface POOContactInfoViewController ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDictionary *phones;

@end

@implementation POOContactInfoViewController

- (POOContactInfoViewController *)initWithName:(NSString *)name lastName:(NSString *)lastName phones:(NSDictionary *)phones {
    _name = name;
    _lastName = lastName;
    _phones = phones;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"Background@2x.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
    [self creatUI];
    
}

- (void)creatUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UILabel *nameLable = [[UILabel alloc] init];
    [nameLable setText:[NSString stringWithFormat:@"%@ %@",_name, _lastName]];
    
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendMessage setTitle:@"Отправить сообщение" forState:UIControlStateNormal];
    [sendMessage setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *phoneNumberButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [phoneNumberButton setBackgroundColor:[UIColor whiteColor]];
    
    if ([_phones objectForKey:@"<Mobile>"]) {
        [phoneNumberButton setTitle:[NSString stringWithFormat:@"Mobile: %@", [_phones objectForKey:@"<Mobile>"]] forState:UIControlStateNormal];
    } else if ([_phones objectForKey:@"<Work>"]) {
        [phoneNumberButton setTitle:[NSString stringWithFormat:@"Work: %@", [_phones objectForKey:@"<Work>"]] forState:UIControlStateNormal];
    } else {
        [phoneNumberButton setTitle:[NSString stringWithFormat:@"Other: %@", [_phones objectForKey:@"<Other>"]] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:imageView];
    [self.view addSubview:nameLable];
    [self.view addSubview:sendMessage];
    [self.view addSubview:phoneNumberButton];
    
    [self creatConstraints:imageView nameLable:nameLable sendMessegeButton:sendMessage phoneNumberButton:phoneNumberButton];
}

- (void)creatConstraints:(UIImageView *)imageView nameLable:(UILabel *)nameLable sendMessegeButton:(UIButton *)sendMessegeButton phoneNumberButton:(UIButton *)phoneNumberButton {
    if (self.view.constraints.count == 0) {
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        nameLable.translatesAutoresizingMaskIntoConstraints = NO;
        sendMessegeButton.translatesAutoresizingMaskIntoConstraints = NO;
        phoneNumberButton.translatesAutoresizingMaskIntoConstraints = NO;
        // imageView Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:INDENT]];
        // lable Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nameLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:INDENT + INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nameLable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:INDENT]];
        // sendMessegeButton Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendMessegeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:INDENT * 7]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendMessegeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sendMessegeButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:INDENT]];
        // phoneNumberButton Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneNumberButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sendMessegeButton attribute:NSLayoutAttributeBottom multiplier:1 constant:INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneNumberButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:phoneNumberButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:INDENT]];
    }
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

@end
