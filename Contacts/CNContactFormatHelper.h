//
//  CNContactFormatHelper.h
//  Contacts
//
//  Created by Hanet on 4/20/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNContactFormatHelper : NSObject

+ (NSDate *) dateFromDateComponents:(NSDateComponents *) dateComponents;
+ (NSMutableArray<NSString *>*) stringArrayFromCNLabeledValueArray:(NSArray<CNLabeledValue *> *) labeledValueArray;
+ (NSString *) sha256HashFor:(NSString *) plaintext;

@end
