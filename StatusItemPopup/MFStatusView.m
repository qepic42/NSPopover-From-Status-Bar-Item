//
//  MFStatusView.m
//  ComplexStatusItem
//
//  Created by Maxim Pervushin on 11/27/12.
//  Copyright (c) 2012 Maxim Pervushin. All rights reserved.
//

#import "MFStatusView.h"

#define ImageViewWidth 22

@interface MFStatusView ()
{
    BOOL _active;
    BOOL _showsPopover;
    
    NSImageView *_imageView;
    
    NSStatusItem *_statusItem;
    NSMenu *_statusItemMenu;
    
    NSPopover *_popover;
}

- (void)updateUI;
- (void)setActive:(BOOL)active;

@end

@implementation MFStatusView

- (id)init
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    self = [super initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
    if (self) {
        
        _active = NO;
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
        [self addSubview:_imageView];

        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:(ImageViewWidth)];
        _statusItem.view = self;

        [self updateUI];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
        NSRectFill(dirtyRect);
    } else {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_showsPopover)
    {
        [self hidePopover];
        _showsPopover = NO;
    }
    else
    {
        [self setActive:YES];
        [self showPopoverWithViewController:[[MFPopoverContentViewController alloc] initWithNibName:@"MFPopoverContentViewController" bundle:nil]];
        
        _showsPopover = YES;
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [self setActive:NO];
}

- (void)updateUI
{
    _imageView.image = [NSImage imageNamed:_active ? @"mf-image-white" : @"mf-image-black"];
    [self setNeedsDisplay:YES];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self updateUI];
}

- (void)showPopoverWithViewController:(NSViewController *)viewController
{
    if (_popover == nil) {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = viewController;
    }
    if (!_popover.isShown) {
        [_popover showRelativeToRect:self.frame
                              ofView:self
                       preferredEdge:NSMinYEdge];
    }
}

- (void)hidePopover
{
    if (_popover != nil && _popover.isShown) {
        [_popover close];
    }
}

#pragma mark - NSMenuDelegate

- (void)menuDidClose:(NSMenu *)menu
{
    [self setActive:NO];
}

@end
