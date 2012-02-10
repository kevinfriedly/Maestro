//
//  MaestroNavViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaestroPlusAppDelegate.h"

@interface MaestroNavViewController : UINavigationController {
}

- (void)showFile:(NSString *)thePath;
- (void)showPlaylist:(NSString *)thePath;
- (NSMutableArray *)getPlaylists;
- (void)setCurrentPlaylist:(NSString *)thePlaylist;

@end
