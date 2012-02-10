//
//  MaestroModel.m
//  MaestroPlus
//
//  Created by Kevin Friedly on 6/16/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import "MaestroModel.h"
#import "PlaylistNameAlert.h"

@implementation MaestroModel

@synthesize myPDFPaths;
@synthesize myTitles;
@synthesize myPlaylists;
@synthesize currentPlaylist;
@synthesize aName;

- (id) init
{
    if (self = [super init])
	{
		self.myPlaylists = [[NSMutableArray alloc] init];
		self.myTitles = [[NSMutableArray alloc] init];		
		self.currentPlaylist = [[NSMutableArray alloc] init];		
	}
    return self;
}

- (void)initModel {
	[self loadModelData];
	
	//NSMutableArray *theLoadedPDFs = [self getPDFs];
	self.myPDFPaths = [self getPDFs];
	NSMutableArray *localArray = [[NSMutableArray alloc] init];
	
	NSString *aString;
	NSArray *aComponent = [[NSArray alloc] init];
	
	//for(NSString *path in theLoadedPDFs) {
	localArray = [self.myTitles copy];
	for(NSString *aTitle in self.myPDFPaths) {
		aComponent = [aTitle componentsSeparatedByString:@"/"];
		aString = (NSString *)[aComponent lastObject];
		int found =0;
		for(NSString *aPath2 in self.myTitles) {
			if([aPath2 compare:aString]) {
				found=1;
				break;
			}
		}
		if(found==0) {
		    [localArray addObject:aString];
		}
		//[self.myTitles addObject:aString];
	}
	self.myTitles = [localArray copy];
	//[self.myTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}	

- (void)saveModelData {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	//NSMutableArray *thePDFs = self.myPDFPaths;
	//NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thePDFs];
	//[prefs setObject:data forKey:@"myPDFPaths"];
	
	NSMutableArray *theTitles = self.myTitles;
	NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:theTitles];
	[prefs setObject:data2 forKey:@"myTitles"];
	
	NSMutableArray *thePlaylists = self.myPlaylists;
	NSData *data3 = [NSKeyedArchiver archivedDataWithRootObject:thePlaylists];
	[prefs setObject:data3 forKey:@"myPlaylists"];
}

- (void)loadModelData {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	//NSData *data = [prefs objectForKey:@"myPDFPaths"];
	//NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	//self.myPDFPaths = arr;
	
	//self.myPDFPaths = [self getPDFs];

	NSData *data2 = [prefs objectForKey:@"myTitles"];
	NSMutableArray *arr2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
	self.myTitles = arr2;

	NSData *data3 = [prefs objectForKey:@"myPlaylists"];
	NSMutableArray *arr3 = [NSKeyedUnarchiver unarchiveObjectWithData:data3];
	self.myPlaylists = arr3;
}

- (NSMutableArray *)getPDFs {
	//  get array of all pdfs
	NSArray *myPDFs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf"
														 inDirectory:nil];
	
	NSMutableArray *returnArray = [myPDFs mutableCopy];
	return returnArray;	
}	

- (NSMutableArray *)getTitles {
	if ([self.myTitles count] < 1) {
		[self getPDFs];
	}
	
	//[self saveModelData];
	return self.myTitles;
}

- (NSMutableArray *)sortTitles {
	NSMutableArray *returnArray = [[NSMutableArray alloc] init];
	returnArray = self.myTitles;
	if(returnArray) {
		[returnArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		//[self.myPDFPaths sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		return returnArray;
	} else {
		return nil;
	}
    [self saveModelData];
}

- (NSString *)getPDFNameFromPath:(NSString *)pdfPath {
	NSArray *theArray = [pdfPath componentsSeparatedByString:@"/"];
	return [[theArray lastObject] stringByDeletingPathExtension];
}

- (NSMutableArray *)newPlaylist {
	NSMutableArray *aNewPlaylist = [[NSMutableArray alloc] initWithObjects:nil];
	[aNewPlaylist addObject:@""];
	return aNewPlaylist;
}

- (NSMutableArray *)getPlaylists {
	return self.myPlaylists;
}

- (int)currentPlaylistLength {
	return [[self getCurrentPlaylistArray] count];
}

- (void)setMyCurrentPlaylist:(NSString *)theName {
	self.currentPlaylist = theName;
}

- (BOOL)removePlaylist:(NSString *)theName {
	NSMutableArray *theList = self.myPlaylists;
	
	NSUInteger counter=0;
	for (NSMutableArray *anArray in theList) {
		if(anArray) {
			if([[anArray objectAtIndex:0] isEqualToString:theName]) {
				[theList removeObjectAtIndex:counter];
				 return 0;
			}
		}
		counter++;
	}
	return 1;
}

-(BOOL)removeFromPlaylist:(NSString *)theName theIndex:(NSUInteger)anIndex {
 	NSMutableArray *theList = self.myPlaylists;
	NSMutableArray *thePDFs = self.myPDFPaths;
	
	NSUInteger counter=0;
	if(!theName) {     // if no playlist is specified then it is to be removed from the main doc list
		theList = thePDFs;
		[theList removeObjectAtIndex:anIndex];
		return 0;
	} else {
		theList = theList;
		for (NSMutableArray *anArray in theList) {
			if(anArray) {
				if([[anArray objectAtIndex:0] isEqualToString:theName]) {
					[anArray removeObjectAtIndex:anIndex];
					return 0;
				}
			}
			counter++;
		}
		return 1;
	}
}

- (NSUInteger)getIndexForNameInPDFList:(NSString *)theName {
 	NSArray *theList = self.myPDFPaths;
		
	NSUInteger counter=1;
	for (NSString *anArray in theList) {
		if(anArray) {
			if([[self getPDFNameFromPath:anArray] isEqualToString:theName]) {
				return counter;
			}
		}
		counter++;
	}
	return 0;
}

- (NSUInteger)getIndexForNameInCurrentPlaylist:(NSString *)theName {
 	NSMutableArray *theList = [self getCurrentPlaylistArray];
	
	NSUInteger counter=1;
	for (NSString *anArray in theList) {
		if(anArray) {
			if([[self getPDFNameFromPath:anArray] isEqualToString:theName]) {
				return counter;
			}
		}
		counter++;
	}
	return 0;
}


- (NSMutableArray *)getCurrentPlaylistArray {
	NSMutableArray *anArray = [[NSMutableArray alloc] initWithObjects:nil];
	for (anArray in self.myPlaylists) {		
		if ([anArray objectAtIndex:0] == self.currentPlaylist) {
			return anArray;
		}
	}
	return anArray;
}

- (BOOL)editCurrentPlaylistName:(NSString *)theName {
	NSMutableArray *theList = self.myPlaylists;
	NSMutableArray *theCurrentPlaylist = [self getCurrentPlaylistArray];
	
	for (NSMutableArray *anArray in theList) {
		if(anArray) {
			if([[anArray objectAtIndex:0] isEqualToString:theName]) {
				NSLog(@"we have a duplicate");
				return 0;
			}
		}
	}
	[theCurrentPlaylist replaceObjectAtIndex:0 withObject:theName];
	self.currentPlaylist = theName;
	return 1;
}

- (NSString *)getCurrentPlaylistName {
	return self.currentPlaylist;
}

- (void)addIndexToPlaylist:(int)theIndex {
	NSMutableArray *theCurrentPlaylist = [self getCurrentPlaylistArray];
	NSString *thePDFName = [self.myTitles objectAtIndex:theIndex];
	 
	for (NSString *anItem in theCurrentPlaylist) {
		if(anItem) {
			if([anItem isEqualToString:thePDFName]) {
				return;
			}
		}
	}
	[self.currentPlaylist addObject:thePDFName];
	NSMutableArray *test = [[NSMutableArray alloc] init];
	[test addObject:thePDFName];
	self.currentPlaylist = [test copy];
	return;
}

- (void)addStringToMainDocList:(NSString *)theString {
	[self.myTitles addObject:theString];
	//[self.myPDFPaths addObject:theString];
}

- (void)addStringToCurrentPlaylist:(NSString *)theString {
	NSMutableArray *theCurrentPlaylist = [self getCurrentPlaylistArray];
	[theCurrentPlaylist addObject:theString];
}

- (void)removeIndexFromPlaylist:(int)theIndex {
	NSMutableArray *theCurrentPlaylist = [self getCurrentPlaylistArray];
	NSString *thePDFName = [theCurrentPlaylist objectAtIndex:theIndex+1];
	
	int counter=0;
	for (NSString *anItem in theCurrentPlaylist) {
		if(anItem) {
			if([anItem isEqualToString:thePDFName]) {
				[theCurrentPlaylist removeObjectAtIndex:counter];
				return;
			}
		}
		counter+=1;
	}
	return;
}	


- (void)addToPlaylists:(NSMutableArray *)aNewPlaylist {
	[self.myPlaylists addObject:aNewPlaylist];
}

- (NSString *)getFilePath:(int)theIndex {
	NSMutableArray *theCurrentPlaylist = [self getCurrentPlaylistArray];
	
	NSString *theName = [theCurrentPlaylist objectAtIndex:theIndex];
	
	NSRange textRange;
	for (NSString *aPath in [self getPDFs]) {
		if(aPath) {
			textRange =[aPath rangeOfString:theName];
			if(textRange.location != NSNotFound) {
			//if([[anArray objectAtIndex:0] isEqualToString:theName]) {
				return aPath;
			}
		}
	}
	return theName;
}

- (NSString *)getFullPath:(NSString *)aTitle {
	NSMutableArray *theList = self.myPDFPaths;
	
	NSRange textRange;
	for (NSString *aString in theList) {
		if(aString) {
			//NSString *justTheTitle = [[aString componentsSeparatedByString:@"/"] lastObject];
			//if([justTheTitle isEqualToString:aTitle]) {
			textRange =[aString rangeOfString:aTitle];
			if(textRange.location != NSNotFound) {
				return aString;
			}
		}
	}
	[self saveModelData];
	
	return @"";
}


@end
