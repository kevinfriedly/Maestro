//
//  MaestroPlusAppDelegate.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaestroModel.h"

@interface MaestroPlusAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	MaestroModel *appModel;
	NSString *previousPlaylist;
}

- (MaestroModel *)getModel;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MaestroModel *appModel;
@property (nonatomic, retain) NSString *previousPlaylist;

@end

