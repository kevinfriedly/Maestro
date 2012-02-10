//
//  TouchView.h
//  MaestroPlus
//
//  Created by Kevin Friedly on 5/18/11.
//  Copyright 2011 Silicon Prairie Ventures, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileViewController.h"

@interface TouchView : UIWebView {
    FileViewController *myFileViewController;
}

@property (nonatomic,retain) IBOutlet FileViewController *myFileViewController;

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event;


@end
