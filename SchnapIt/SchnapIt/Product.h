//
//  Product.h
//  SchnapIt
//
//  Created by DAVID HAYDEN on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject {
    NSString *_name;
    NSString *_buyURL;
    NSString *_summary;
    int _rating;
    float _price;
    UIImage *_image;

}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * buyURL;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic) int rating;
@property (nonatomic) float price;
@property (nonatomic, retain) UIImage * image;

-(id) initWithTitle:(NSString *)name 
             buyURL:(NSString *)buyURL 
            summary:(NSString *)summary 
             rating:(int)rating 
              price:(float)price
              image:(UIImage *)image;

-(NSString *) getNaturalRating;

+(id) getMacbookLaptop;
+(id) getLenovoLaptop;

@end