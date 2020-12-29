//
//  UIApplication+Screenshot.m
//  Alpha
//
//  Created by Dal Rupnik on 29/11/2016.
//  Copyright © 2016 Unified Sense. All rights reserved.
//

#import "UIApplication+Screenshot.h"
#import "UIView+Snapshot.h"

#import "UIApplication+Screenshot.h"

@import UIKit;

@implementation UIApplication (Screenshot)

- (UIImage *)alpha_screenshot
{
    return [self alpha_screenshotExcludingWindows:nil withStatusBar:YES];
}

- (UIImage *)alpha_screenshotExcludingWindows:(NSArray *)windows
{
    return [self alpha_screenshotExcludingWindows:windows withStatusBar:YES];
}

- (UIImage *)alpha_screenshotExcludingWindows:(NSArray *)windows withStatusBar:(BOOL)statusBar
{
    NSMutableArray* sourceWindows = [self.windows mutableCopy];
    
    if (windows.count)
    {
        [sourceWindows removeObjectsInArray:windows];
    }
    
    if (statusBar && [self statusBarView])
    {
        [sourceWindows addObject:[self statusBarView]];
    }
    
    return [self imageByCombiningImages:[self imagesFromViews:sourceWindows]];
}

- (NSArray *)imagesFromViews:(NSArray *)views
{
    NSMutableArray* images = [NSMutableArray array];
    
    for (UIView *view in views)
    {
        [images addObject:[view alpha_snapshotImageWithScale:2.0]];
    }
    
    return [images copy];
}

- (UIImage *)imageByCombiningImages:(NSArray *)images
{
    UIImage *finalImage = nil;
    
    //
    // Find Max size
    //
    
    CGSize newImageSize = CGSizeZero;
    
    for (UIImage *image in images)
    {
        if (image.size.width > newImageSize.width)
        {
            newImageSize.width = image.size.width;
        }
        
        if (image.size.height > newImageSize.height)
        {
            newImageSize.height = image.size.height;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    
    for (UIImage *image in images)
    {
        [image drawInRect:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    }
    
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}

/**
 *  Private method returns status bar view
 *
 *  @return status bar view
 */
- (UIView *)statusBarView
{
    if (@available(iOS 13.0, *)) {
        NSInteger tag = 38482;
        UIWindow *keyWindow = UIApplication.sharedApplication.windows.firstObject;
        UIView *statusBar = [keyWindow viewWithTag:tag];
        if (statusBar) {
            return statusBar;
        } else {
            CGRect statusBarFrame = keyWindow.windowScene.statusBarManager.statusBarFrame;
            if (CGRectEqualToRect(statusBarFrame, CGRectZero)) {
                return nil;
            }
            UIView *statusBarView = [[UIView alloc] initWithFrame:statusBarFrame];
            statusBarView.tag = tag;
            [keyWindow addSubview:statusBarView];
            return statusBarView;
        }
    } else {
        return [self valueForKey:@"statusBar"];
    }
}

@end
