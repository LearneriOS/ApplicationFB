//
//  POOContactInfoViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 25.01.16.
//  Copyright © 2016 Oleh Petrunko. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "POOContactInfoViewController.h"

static NSInteger INDENT = 20;

@interface POOContactInfoViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

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

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _phones.allKeys.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_phones.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *curentKey = [_phones.allKeys objectAtIndex:section];
    NSArray *numberOfRowsInSectionArray = [NSArray arrayWithObject:[_phones objectForKey:curentKey]];
    
    return numberOfRowsInSectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    NSString *curentKey = [_phones.allKeys objectAtIndex:indexPath.section];
    cell.textLabel.text = [_phones objectForKey:curentKey];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma - UI
- (void)creatUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UILabel *nameLable = [[UILabel alloc] init];
    [nameLable setText:[NSString stringWithFormat:@"%@ %@",_name, _lastName]];
    
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendMessage setTitle:@"Отправить сообщение" forState:UIControlStateNormal];
    [sendMessage setBackgroundColor:[UIColor whiteColor]];
    [sendMessage addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchDown];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:imageView];
    [self.view addSubview:nameLable];
    [self.view addSubview:sendMessage];
    [self.view addSubview:tableView];
    
    [self creatConstraints:imageView nameLable:nameLable sendMessegeButton:sendMessage tableView:tableView];
}

- (void) sendMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Заглушка" message:@"Реализовать отправку сообщений" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:NO completion:NULL];
}

#pragma mark - Constrains
- (void)creatConstraints:(UIImageView *)imageView nameLable:(UILabel *)nameLable sendMessegeButton:(UIButton *)sendMessegeButton tableView:(UITableView *)tableView {
    if (self.view.constraints.count == 0) {
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        nameLable.translatesAutoresizingMaskIntoConstraints = NO;
        sendMessegeButton.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
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
        // tableView Contstarins
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sendMessegeButton attribute:NSLayoutAttributeBottom multiplier:1 constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeTrailing multiplier:1 constant:INDENT]];
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
