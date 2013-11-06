//
//  NSToolbarBadgedItem.h
//  ToolbarBadges
//
//  Created by Robert McDowell on 04/11/2013.
//  Copyright (c) 2013 Bert McDowell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSToolbarBadgedItem : NSToolbarItem

@property (nonatomic, copy) NSString* badgeValue;

@property (nonatomic, copy) NSString * badgeFontName;
@property (nonatomic, copy) NSColor * badgeTextColor;
@property (nonatomic, copy) NSColor * badgeTextShadowColor;

@property (nonatomic, copy) NSColor * badgeLineColor;
@property (nonatomic, copy) NSColor * badgeFillColor;
@property (nonatomic, copy) NSColor * badgeShadowColor;

@end
