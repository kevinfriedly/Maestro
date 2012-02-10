//
//  FileListViewController.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FileListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {	
	IBOutlet UITableView *docTable;
}

- (NSUInteger)indexFromIndexPath:(NSIndexPath*)indexPath;

@property (nonatomic, retain) UITableView *docTable;

UITextField *textfieldName;

@end
