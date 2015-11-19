//
//  POOFacebookFeed.m
//  OutputFaceBookData
//
//  Created by Oleh Petrunko on 02.11.15.
//  Copyright © 2015 Oleh Petrunko. All rights reserved.
//

#import "POOFacebookFeed.h"

@implementation POOFacebookFeed

- (POOFacebookFeed *) initWithDictionary:(NSDictionary *)feed {
    self.message = [feed objectForKey:@"message"];
    self.timeCreat = [feed objectForKey:@"created_time"];
    NSLog(@"%@",self.timeCreat);
    self.image = [NSURL URLWithString:[feed objectForKey:@"picture"]];
    
    NSMutableArray *pictures = [NSMutableArray array];
    
    NSArray *array =[[feed objectForKey:@"attachments"] objectForKey:@"data"];
    for (NSDictionary *tempPictureDictionary in array) {
        
        if ([tempPictureDictionary objectForKey:@"subattachments"]) {
            NSArray *tempArray = [[tempPictureDictionary objectForKey:@"subattachments"] objectForKey:@"data"];
            
            for (NSDictionary *picture in tempArray) {
                [pictures addObject:[[[picture objectForKey:@"media"] objectForKey:@"image"] objectForKey:@"src"]];
            }
        }
        else {
            [pictures addObject:[[[tempPictureDictionary objectForKey:@"media"] objectForKey:@"image"] objectForKey:@"src"]];
        }
    }
    self.images = pictures;
    NSLog(@"-------------- %@ --------------",self.images);
    return self;
}

@end

