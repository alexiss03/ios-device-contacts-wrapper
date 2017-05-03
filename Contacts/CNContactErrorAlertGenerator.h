//
//  CNContactErrorAlertGenerator.h
//  Contacts
//
//  Created by Hanet on 5/3/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CNContactErrorAlertGenerator : NSObject

+ (UIAlertController *) generateAlertFromError:(NSError *) error;

@end
