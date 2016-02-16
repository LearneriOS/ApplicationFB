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
#import "Consts.h"
#import "StringLocalizer.h"

@interface POOContactInfoViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDictionary *phones;

@end

@implementation POOContactInfoViewController

- (POOContactInfoViewController *)initWithName:(NSString *)name lastName:(NSString *)lastName phones:(NSDictionary *)phones {
    self.name = name;
    self.lastName = lastName;
    self.phones = phones;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"Background"]]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    
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
    NSString *curentKey = [_phones.allKeys objectAtIndex:indexPath.section];
    [self ShowSMS:[_phones objectForKey:curentKey]];
}

- (void) ShowSMS:(NSString *) phone {
    
    if(![MFMessageComposeViewController canSendText]) {
        
        NSLog(@"device doesn't support SMS!");
        return;
    }
    
    NSArray *recipents = @[phone];
    NSString *message = [NSString stringWithFormat:@"Some Text"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma - UI
- (void)creatUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"Placeholder"]];
    
    UILabel *nameLable = [[UILabel alloc] init];
    [nameLable setText:[NSString stringWithFormat:@"%@ %@",_name, _lastName]];
    
    UIButton *sendMessage = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendMessage setTitle:[@"sendMessageText" localized] forState:UIControlStateNormal];
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
    
    
    if(![MFMessageComposeViewController canSendText]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"device doesn't support SMS!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:NO completion:NULL];
    }
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to send SMS!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:ok];
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
           
        case MessageComposeResultSent:
            break;
            
        case MessageComposeResultFailed:
            [self presentViewController:alertController animated:YES completion:NULL];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Constrains
- (void)creatConstraints:(UIImageView *)imageView nameLable:(UILabel *)nameLable sendMessegeButton:(UIButton *)sendMessegeButton tableView:(UITableView *)tableView {
    if (self.view.constraints.count == 0) {
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        nameLable.translatesAutoresizingMaskIntoConstraints = NO;
        sendMessegeButton.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        // imageView Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:kConstsIndent]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:kConstsIndent]];
        // lable Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nameLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:kConstsIndent + kConstsIndent]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nameLable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:kConstsIndent]];
        // sendMessegeButton Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendMessegeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:kConstsIndent * 7]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendMessegeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:sendMessegeButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:kConstsIndent]];
        // tableView Contstarins
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sendMessegeButton attribute:NSLayoutAttributeBottom multiplier:1 constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeBottom multiplier:1 constant:kConstsIndent]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tableView attribute:NSLayoutAttributeTrailing multiplier:1 constant:kConstsIndent]];
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
