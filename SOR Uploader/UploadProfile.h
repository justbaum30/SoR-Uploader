//
//  UploadProfile.h
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/4/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadProfile : NSObject <NSCoding>

@property(copy) NSString *name;
@property(copy) NSString *receiptPath;
@property(copy) NSString *mileagePath;

- (id)initWithName:(NSString *)aName
       ReceiptPath:(NSString *)aReceiptPath
       MileagePath:(NSString *)aMileagePath;

@end
