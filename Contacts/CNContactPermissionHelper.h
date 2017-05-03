//
//  CNContactPermissionHelper.h
//  Contacts
//
//  Created by Hanet on 4/24/17.
//  Copyright © 2017 Mary Alexis Solis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNContactPermissionHelper : NSObject

+ (void) requestContactPermissionCompletionHandler:(void(^)(BOOL authorized, NSError * error)) completionHandler;

@end
