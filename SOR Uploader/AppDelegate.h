//
//  AppDelegate.h
//  SOR Uploader
//
//  Created by Justin Baumgartner  on 8/3/14.
//  Copyright (c) 2014 Justin Baumgartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, DBSessionDelegate, DBNetworkRequestDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
