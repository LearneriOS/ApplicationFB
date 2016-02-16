//
//  POORegistrationViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 15.12.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POORegistrationViewController.h"
#import "Consts.h"
#import "StringLocalizer.h"

typedef void (^CompletionHandler)(NSUInteger response, NSError *error);

@interface POORegistrationViewController ()

@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *phone;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *repeatPassword;
@property (nonatomic, strong) UITextField *confimPassword;

@end

@implementation POORegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubView];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"Background"]]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.topItem.title = [@"navigationController.navigationBar.topItem.titleText" localized];
    
}
#pragma mark button clicked
- (void) vkRegistration {
    NSString *checkPhoneRequest = [NSString stringWithFormat: @"https://api.vk.com/method/auth.checkPhone?phone=%@&client_id=%@&client_secret=%@",self.phone.text, kConstsAppId, kConstsSecret];
    
    [self doRequestByStringWithBlock:checkPhoneRequest block:^(NSUInteger code, NSError *error) {
        
        if (code  == 1 && ![self.firstName.text  isEqual: @""] && ![self.lastName.text  isEqual: @""] && ![self.password.text  isEqual: @""]) {
            NSString *authorizationRequest = [NSString stringWithFormat:@"https://api.vk.com/method/auth.signup?first_name=%@&last_name=%@&client_id=%@&client_secret=%@&phone=%@&password=%@&test_mode=1",self.firstName.text, self.lastName.text, kConstsAppId, kConstsSecret, self.phone.text, self.password.text];
            [self doRequestByString:authorizationRequest];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self creatConfirmWindow];
            });
        } else if(code == 1000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"phoneErrorText1" localized] attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else if(code == 1004) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"phoneErrorText2" localized] attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else if (code == 100) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"phoneErrorText3" localized]attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"phoneErrorText4" localized] attributes:@{NSForegroundColorAttributeName: color}];
            });
        }
    }];
}

#pragma mark AlertViews. End registration
- (void) creatConfirmWindow {
    UIAlertController *passwordConfirmation = [UIAlertController alertControllerWithTitle:[@"passwordConfirmationText" localized] message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *confirmationRegistration = [NSString stringWithFormat:@"https://api.vk.com/method/auth.confirm?client_id=%@&client_secret=%@&phone=%@&code=%@&test_mode=1",kConstsAppId, kConstsSecret, self.phone.text, self.confimPassword.text];
        [self doRequestByStringWithBlock:confirmationRegistration block:^(NSUInteger code, NSError *error) {
            [self buildAllertControllerWithFlag:code];
        }];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:[@"Cancel" localized] style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [passwordConfirmation dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [passwordConfirmation addAction:ok];
    [passwordConfirmation addAction:cancel];
    [passwordConfirmation addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = [@"textField.placeholderText" localized];
        self.confimPassword = textField;
    }];
    
    [self presentViewController:passwordConfirmation animated:YES completion:nil];
}

- (void) buildAllertControllerWithFlag:(NSInteger) flag {
    UIAlertController *alertController = nil;
    UIAlertAction *ok = nil;
    if (flag == 1) {
        alertController = [UIAlertController alertControllerWithTitle:[@"alertControllerOKText" localized] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:[@"alertControllerNotOKText" localized] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self creatConfirmWindow];
        }];
    }
    [alertController addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - Requests
- (void) doRequestByString:(NSString *) stringRequest {
    NSURL *url = [NSURL URLWithString:stringRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if(jsonError) {
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            NSLog(@"%@",jsonDictionary);
        }
    }];
    
    [dataTask resume];
}

- (void) doRequestByStringWithBlock:(NSString *)stringRequest block:(CompletionHandler)completionHandler {
    NSURL *chekPhoneURL = [NSURL URLWithString:stringRequest];
    NSURLRequest *checkPhoneRequest = [NSURLRequest requestWithURL:chekPhoneURL];
    
    NSURLSessionDataTask *checkPhoneDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:checkPhoneRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            if (error) {
                completionHandler(0, error);
            } else {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if(jsonError) {
                    NSLog(@"json error : %@", [jsonError localizedDescription]);
                } else if([jsonDictionary objectForKey:@"response"]) {
                    id responsId = [jsonDictionary objectForKey:@"response"];
                    
                    if ([responsId isKindOfClass:[NSNumber class]]) {
                        
                        completionHandler(((NSNumber *)responsId).integerValue, jsonError);
                    }
                } else {
                    completionHandler(0, jsonError);
                }
                NSLog(@"%@", jsonDictionary);
            }
        }
    }];
    
    [checkPhoneDataTask resume];
}
#pragma mark - Build subView
- (void) creatSubView {
    self.firstName = [[UITextField alloc] init];
    [self.firstName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.firstName setPlaceholder:[@"firstNameText" localized]];
    
    self.lastName = [[UITextField alloc] init];
    [self.lastName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.lastName setPlaceholder:[@"lastNameText" localized]];
    
    self.phone = [[UITextField alloc] init];
    [self.phone setBorderStyle:UITextBorderStyleRoundedRect];
    [self.phone setPlaceholder:[@"phoneText" localized]];
    [self.phone setPlaceholder:[@"380995031116" localized]];
    
    self.password = [[UITextField alloc] init];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password setPlaceholder:[@"passwordText" localized]];
    self.password.secureTextEntry = YES;
    
    //    self.repeatPassword = [[UITextField alloc] init];
    //    [self.repeatPassword setBorderStyle:UITextBorderStyleRoundedRect];
    //    [self.repeatPassword setPlaceholder:@"Повторите пароль"];
    //    self.repeatPassword.secureTextEntry = YES;
    
    UIButton *registrationButton = [UIButton new];
    [registrationButton setTitle:[@"registrationButtonText" localized] forState:UIControlStateNormal];
    registrationButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [registrationButton setImageEdgeInsets:UIEdgeInsetsMake(0, registrationButton.frame.origin.x + 100, 0, 0)];
    [registrationButton setBackgroundImage:[UIImage imageNamed:@"LoginButton"] forState:UIControlStateNormal];
    [registrationButton setImage:[UIImage imageNamed:@"WhiteArrow"] forState:UIControlStateNormal];
    [registrationButton addTarget:self action:@selector(vkRegistration) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.firstName];
    [self.view addSubview:self.lastName];
    [self.view addSubview:self.phone];
    [self.view addSubview:self.password];
    [self.view addSubview:registrationButton];
    [self creatConstrainsToSubView:registrationButton];
}

#pragma mark - Creat constrains to subView
- (void) creatConstrainsToSubView:(UIButton *)registrationButton {
    if (self.view.constraints.count == 0) {
        
        registrationButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.firstName.translatesAutoresizingMaskIntoConstraints = NO;
        self.lastName.translatesAutoresizingMaskIntoConstraints = NO;
        self.phone.translatesAutoresizingMaskIntoConstraints = NO;
        self.password.translatesAutoresizingMaskIntoConstraints = NO;
        // textfiled name
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.firstName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:kConstsIndent]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.firstName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.firstName attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kConstsIndent]];
        // textfiled last name
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lastName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lastName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view   attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.lastName attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kConstsIndent]];
        // textfiled phone
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.phone attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lastName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.phone attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.phone attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kConstsIndent]];
        //    textfiled password
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.password attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phone attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.password attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.password attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kConstsIndent]];
        //reg button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:registrationButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.password attribute:NSLayoutAttributeBottom multiplier:1.0f constant:kConstsIndent]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:registrationButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:kConstsIndent]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:registrationButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:kConstsIndent]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
