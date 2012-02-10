//
//  MaestroModel.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 6/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaestroModel : NSObject {
	NSMutableArray *myPDFPaths;
	NSMutableArray *myTitles;
	NSMutableArray *myPlaylists;
	NSString *currentPlaylist;
	NSString *aName;
}

- (void)initModel;
- (void)saveModelData;
- (void)loadModelData;
- (NSMutableArray *)getPlaylists;
- (NSMutableArray *)getPDFs;
- (NSMutableArray *)getTitles;
- (NSMutableArray *)sortTitles;
- (NSString *)getFullPath:(NSString *)aTitle;
- (NSString *)getPDFNameFromPath:(NSString *)pdfPath;
- (NSMutableArray *)newPlaylist;
- (int)currentPlaylistLength;
- (NSMutableArray *)getCurrentPlaylistArray;
- (BOOL)editCurrentPlaylistName:(NSString *)theName;
- (void)setMyCurrentPlaylist:(NSString *)theName;
- (BOOL)removePlaylist:(NSString *)theName;
- (BOOL)removeFromPlaylist:(NSString *)theName theIndex:(NSUInteger)anIndex;
- (NSString *)getCurrentPlaylistName;
- (void)addIndexToPlaylist:(int)theIndex;
- (void)addStringToCurrentPlaylist:(NSString *)theString;
- (void)addStringToMainDocList:(NSString *)theString;
- (void)addToPlaylists:(NSMutableArray *)aNewPlaylist;
- (NSString *)getFilePath:(int)theIndex;
- (NSUInteger)getIndexForNameInPDFList:(NSString *)theName;
- (NSUInteger)getIndexForNameInCurrentPlaylist:(NSString *)theName;

@property (nonatomic, retain) NSMutableArray *myPlaylists;
@property (nonatomic, retain) NSMutableArray *myPDFPaths;
@property (nonatomic, retain) NSMutableArray *myTitles;
@property (nonatomic, retain) NSString *currentPlaylist;
@property (nonatomic, retain) NSString *aName;

@end
