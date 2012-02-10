//
//  PlaylistViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayListDisplay : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *myTable;
}

@property (retain,nonatomic) IBOutlet UITableView *myTable;

- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath;
- (void)addPlaylist:(id)sender;

@end
