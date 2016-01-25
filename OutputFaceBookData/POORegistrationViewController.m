//
//  POORegistrationViewController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 15.12.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POORegistrationViewController.h"
#import <CoreData/CoreData.h>

static NSString *APP_ID = @"5187957";
static NSString *SECRET = @"sBsolEPAesngv7KAXDv7";
static NSInteger INDENT = 20;

typedef void (^CompletionHandler)(NSString *response, NSError *error);

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: @"Background@2x.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"Header_black@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.topItem.title = @"Регистрация";
    
}
#pragma mark button clicked
- (void) vkRegistration {
    NSString *checkPhoneRequest = [NSString stringWithFormat: @"https://api.vk.com/method/auth.checkPhone?phone=%@&client_id=%@&client_secret=%@",self.phone.text, APP_ID, SECRET];
    
    [self doRequestByStringWithBlock:checkPhoneRequest block:^(NSString *response, NSError *error) {
        
        if ([response integerValue] == 1 && ![self.firstName.text  isEqual: @""] && ![self.lastName.text  isEqual: @""] && ![self.password.text  isEqual: @""]) {
            NSString *authorizationRequest = [NSString stringWithFormat:@"https://api.vk.com/method/auth.signup?first_name=%@&last_name=%@&client_id=%@&client_secret=%@&phone=%@&password=%@&test_mode=1",self.firstName.text, self.lastName.text, APP_ID, SECRET, self.phone.text, self.password.text];
            [self doRequestByString:authorizationRequest];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self creatConfirmWindow];
            });
        } else if([response integerValue] == 1000) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Неверный номер" attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else if([response integerValue] == 1004) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Номер телефона занят другим пользователем." attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else if ([response integerValue] == 100) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Неверно введен номер" attributes:@{NSForegroundColorAttributeName: color}];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.phone.text = nil;
                UIColor *color = [UIColor redColor];
                self.phone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Не все поля были заполнены" attributes:@{NSForegroundColorAttributeName: color}];
            });
        }
    }];
}

#pragma mark AlertViews. End registration
- (void) creatConfirmWindow {
    UIAlertController *passwordConfirmation = [UIAlertController alertControllerWithTitle:@"Введите Пароль" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *confirmationRegistration = [NSString stringWithFormat:@"https://api.vk.com/method/auth.confirm?client_id=%@&client_secret=%@&phone=%@&code=%@&test_mode=1",APP_ID, SECRET, self.phone.text, self.confimPassword.text];
        [self doRequestByStringWithBlock:confirmationRegistration block:^(NSString *response, NSError *error) {
            [self buildAllertControllerWithFlag:[response integerValue]];
        }];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [passwordConfirmation dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [passwordConfirmation addAction:ok];
    [passwordConfirmation addAction:cancel];
    [passwordConfirmation addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Пароль подтверждения регистрации";
        self.confimPassword = textField;
    }];
    
    [self presentViewController:passwordConfirmation animated:YES completion:nil];
}

- (void) buildAllertControllerWithFlag:(NSInteger) flag {
    UIAlertController *alertController = nil;
    UIAlertAction *ok = nil;
    if (flag == 1) {
        alertController = [UIAlertController alertControllerWithTitle:@"Регистрация прошла успешно" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    } else {
        alertController = [UIAlertController alertControllerWithTitle:@"Неправильны пароль" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

- (void) doRequestByStringWithBlock:(NSString *)stringRequest block:(void (^)(NSString *response, NSError *error))completionHandler {
    NSURL *chekPhoneURL = [NSURL URLWithString:stringRequest];
    NSURLRequest *checkPhoneRequest = [NSURLRequest requestWithURL:chekPhoneURL];
    
    NSURLSessionDataTask *checkPhoneDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:checkPhoneRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            if (error) {
                completionHandler(nil,error);
            } else {
                NSError *jsonError;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if(jsonError) {
                    NSLog(@"json error : %@", [jsonError localizedDescription]);
                } else if([jsonDictionary objectForKey:@"response"]) {
                    completionHandler([jsonDictionary objectForKey:@"response"], jsonError);
                } else {
                    completionHandler([[jsonDictionary objectForKey:@"error"] objectForKey:@"error_code"], jsonError);
                }
                NSLog(@"%@",jsonDictionary);
            }
        }
    }];
    
    [checkPhoneDataTask resume];
}
#pragma mark - Build subView
- (void) creatSubView {
    self.firstName = [[UITextField alloc] init];
    [self.firstName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.firstName setPlaceholder:@"Ваше имя"];
    
    self.lastName = [[UITextField alloc] init];
    [self.lastName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.lastName setPlaceholder:@"Ваша фамилия"];
    
    self.phone = [[UITextField alloc] init];
    [self.phone setBorderStyle:UITextBorderStyleRoundedRect];
    [self.phone setPlaceholder:@"Номер телефона"];
    [self.phone setPlaceholder:@"380995031116"];
    
    self.password = [[UITextField alloc] init];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password setPlaceholder:@"Пароль"];
    self.password.secureTextEntry = YES;
    
    //    self.repeatPassword = [[UITextField alloc] init];
    //    [self.repeatPassword setBorderStyle:UITextBorderStyleRoundedRect];
    //    [self.repeatPassword setPlaceholder:@"Повторите пароль"];
    //    self.repeatPassword.secureTextEntry = YES;
    
    UIButton *registrationButton = [UIButton new];
    [registrationButton setTitle:@"Зарегистрироваться" forState:UIControlStateNormal];
    registrationButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [registrationButton setImageEdgeInsets:UIEdgeInsetsMake(0, registrationButton.frame.origin.x + 100, 0, 0)];
    [registrationButton setBackgroundImage:[UIImage imageNamed:@"LoginButton@2x.png"] forState:UIControlStateNormal];
    [registrationButton setImage:[UIImage imageNamed:@"WhiteArrow@2x.png"] forState:UIControlStateNormal];
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
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.firstName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.firstName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.firstName attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:INDENT]];
        // textfiled last name
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lastName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lastName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view   attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.lastName attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:INDENT]];
        // textfiled phone
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.phone attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lastName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.phone attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.phone attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:INDENT]];
        //    textfiled password
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.password attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.phone attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.password attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.password attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:INDENT]];
        //reg button
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:registrationButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.password attribute:NSLayoutAttributeBottom multiplier:1.0f constant:INDENT]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:registrationButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:INDENT]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:registrationButton attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:INDENT]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
