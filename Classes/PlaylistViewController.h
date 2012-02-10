//
//  PlaylistViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/20/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaylistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *myTable;
}

@property (retain,nonatomic) IBOutlet UITableView *myTable;

- (void)setEditing:(BOOL)editing animated:(BOOL)animate;
- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath;
- (void)addPlayList:(id)sender;
- (void)editPlayList:(id)sender;
	
@end
