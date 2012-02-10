//
//  PlaylistAddView.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 6/1/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlaylistAddView : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *theDocuments;
	IBOutlet UITableView *thePlaylist;
	IBOutlet UITextField *thePlaylistName;
}

- (IBAction)playListNameChange:(id)sender;

@property (nonatomic, retain) UITableView *theDocuments;
@property (nonatomic, retain) UITableView *thePlaylist;
@property (nonatomic, retain) IBOutlet UITextField *thePlaylistName;

UITextField *textfieldName;

@end
