//
//  POOWebController.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 30.10.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOWebController.h"
#import "POOFacebookFeed.h"

@interface POOWebController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webViewController;
 
@end

@implementation POOWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUIWebController];
    [self creatToolBarWithItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) creatUIWebController {
    self.webViewController = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSString *urlString = @"https://www.google.ru/qwe";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webViewController loadRequest:request];
    [self.view addSubview:self.webViewController];
}
- (void) goBack {
    [self.webViewController goBack];
}
- (void) goForward {
    [self.webViewController goForward];
}
- (void) creatToolBarWithItem {
    UIToolbar *bar = [[UIToolbar alloc] init];
    bar.frame = CGRectMake(0, self.view.frame.size.height - 97, self.view.frame.size.width, 50);
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [bar setItems:@[back,flexibleSpace,forward]];
    
    [self.view addSubview:bar];
    
    self.webViewController.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webViewController]|" options:0 metrics:@{} views:@{@"webViewController": _webViewController}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webViewController]-(-50)-[bar]" options:0 metrics:@{} views:@{@"webViewController": _webViewController, @"bar" : bar}]];
}

@end
