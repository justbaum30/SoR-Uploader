//
//  UploadProfileStore.h
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/8/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UploadProfile;

@interface UploadProfileStore : NSObject

+ (UploadProfileStore *)sharedStore;

- (NSArray *)allProfiles;
- (void)addProfile:(UploadProfile *)profile;
- (void)updateProfile:(UploadProfile *)profile
              atIndex:(NSUInteger)index;
- (void)removeProfileAtIndex:(NSUInteger)index;

@end
