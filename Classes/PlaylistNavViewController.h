//
//  PlaylistNavViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaestroPlusAppDelegate.h"

@interface PlaylistNavViewController : UINavigationController {
}

- (void)showPlaylist:(NSString *)thePath;
- (void)usePlaylist:(NSString *)thePath;
- (void)addPlaylist;
- (NSMutableArray *)getPlaylists;
- (NSMutableArray *)newPlaylist;
- (void)setCurrentPlaylist:(NSString *)thePlaylist;

@end
