// MIT License
//
// Copyright (c) 2016 leeping(平果太郎)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "LPAMenu.h"

static const CGFloat LPAMenuViewAnimationDurition = 0.5f;
static const NSUInteger LPAMenuDefaultCellMaxCount = 3;
static const NSInteger LPAMenuMaxCount = 21;

typedef void(^LPAMenuButtonAnimationFinished)(BOOL finished);

// LPAMenuManager
@interface LPAMenuManager : NSObject

+ (void)addLPAMenu:(LPAMenu *)menu;
+ (void)removeLPAMenu:(LPAMenu *)menu;

@end

@implementation LPAMenuManager
{
    NSMutableArray *_lpaMenus;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lpaMenus = [NSMutableArray array];
    }
    return self;
}

+ (void)addLPAMenu:(LPAMenu *)menu
{
    [[self __instance] __addLPAMenu:menu];
}

+ (void)removeLPAMenu:(LPAMenu *)menu
{
    [[self __instance] __removeLPAMenu:menu];
}

+ (instancetype)__instance
{
    static LPAMenuManager *gLPAMenuManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (gLPAMenuManager == nil) {
            gLPAMenuManager = [[LPAMenuManager alloc] init];
        }
    });
    return gLPAMenuManager;
}

- (void)__addLPAMenu:(LPAMenu *)menu
{
    [_lpaMenus addObject:menu];
}

- (void)__removeLPAMenu:(LPAMenu *)menu
{
    [_lpaMenus removeObject:menu];
}

@end

@interface LPAMenu ()

@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, assign, getter=isShow) BOOL show;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIVisualEffectView *backgroundView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong, readwrite) NSMutableArray<LPAMenuItem *> *items;

@end

@implementation LPAMenu

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellMaxCount = LPAMenuDefaultCellMaxCount;
        _items = [NSMutableArray array];
        _itemViews = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithMenuItems:(NSArray<LPAMenuItem *> *)menuItems
{
    self = [self init];
    if (self) {
        _items = [NSMutableArray arrayWithArray:menuItems];
    }
    return self;
}

#pragma mark - Public Methods

- (void)addMenuItem:(LPAMenuItem *)menuItem
{
    [_items addObject:menuItem];
}

- (void)addMenuItems:(NSArray<LPAMenuItem *> *)menuItems
{
    [_items addObjectsFromArray:menuItems];
}

- (void)show
{
    if (!self.isShow) {
        _show = YES;
        
        [_itemViews removeAllObjects];
        [self.window setHidden:NO];
        [self.window makeKeyAndVisible];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [LPAMenuManager addLPAMenu:self];
        [UIView animateWithDuration:LPAMenuViewAnimationDurition animations:^{
            [self.backgroundView setAlpha:1];
            [self.closeButton setAlpha:1];
        }completion:^(BOOL finished){
            if (finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [self.window bringSubviewToFront:self.closeButton];
            }
        }];
        // Init items
        [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (idx == LPAMenuMaxCount) {
                *stop = YES;
            }
            if (obj) {
                [self __drawItem:obj index:idx];
            }
        }];
    }
}

- (void)dismiss
{
    if (_show) {
        _show = NO;
        
        [self __removeCategoryButtons:nil];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:LPAMenuViewAnimationDurition animations:^{
            [self.backgroundView setAlpha:0];
            [self.closeButton setAlpha:0];
        }completion:^(BOOL finished){
            if (finished) {
                [self.window resignKeyWindow];
                [self.window setHidden:YES];
                [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                if (self.delegate && [self.delegate respondsToSelector:@selector(lpaMenuDidDismiss:)]) {
                    [self.delegate lpaMenuDidDismiss:self];
                }
            }
            [LPAMenuManager removeLPAMenu:self];
        }];
    }
}

#pragma mark - Event Response

- (void)__menuButtonHandler:(UIButton *)button
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(lpaMenu:didSelectedAtIndex:)]) {
        [self.delegate lpaMenu:self didSelectedAtIndex:button.tag];
    }
    // Handler button event
    LPAMenuItem *menuItem = [self.items objectAtIndex:button.tag];
    if (menuItem.subItem.count) {
        [self __removeCategoryButtons:^(BOOL finished){
            if (finished) {
                // Create sub items
                [_itemViews removeAllObjects];
                [menuItem.subItem enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                    if (idx == LPAMenuMaxCount) {
                        *stop = YES;
                    }
                    if (obj) {
                        [self __drawItem:obj index:idx];
                    }
                }];
            }
        }];
    }else if (menuItem.selectedBlock) {
        LPAMenuSelectBlock block = menuItem.selectedBlock;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            block();
        });
        // Close window
        [self dismiss];
    }
}

- (void)__closeButtonHandler:(UIButton *)button
{
    [self dismiss];
}

#pragma mark - Private Methods

- (void)__drawItem:(LPAMenuItem *)menuItem index:(NSInteger)idx
{
    if (self.cellMaxCount > 4) {
        self.cellMaxCount = 4;
    }
    NSInteger row = self.items.count / self.cellMaxCount + 1;
    NSInteger curRow = idx / self.cellMaxCount;
    NSInteger curCol = idx - curRow * self.cellMaxCount;
    CGFloat itemWidth = CGRectGetWidth(self.window.frame) / self.cellMaxCount;
    CGFloat itemHeight = itemWidth * 0.8f;
    CGFloat originY = (CGRectGetHeight(self.window.frame) - itemHeight * row) / 2;
    CGRect categoryRect = CGRectMake(curCol * itemWidth, originY + curRow * itemHeight,
                                     itemWidth, itemHeight);
    CGRect originRect = CGRectMake(curCol * itemWidth, CGRectGetHeight(self.window.frame) + itemHeight, itemWidth, itemHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:originRect];
    [contentView setBackgroundColor:[UIColor clearColor]];
    // Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:idx];
    [button setFrame:CGRectMake((CGRectGetWidth(contentView.frame) - (itemHeight - 28)) / 2, 8,
                                itemHeight - 28, itemHeight - 28)];
    [button setBackgroundImage:menuItem.image forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeScaleToFill];
    [button addTarget:self action:@selector(__menuButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    // Label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, itemHeight - 20,
                                                               CGRectGetWidth(contentView.frame), 20)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor blackColor]];
    [label setText:menuItem.title];
    [contentView addSubview:button];
    [contentView addSubview:label];
    [self.window addSubview:contentView];
    [_itemViews addObject:contentView];
    [UIView animateWithDuration:0.5 + idx * 0.1f
                          delay:0.0f
         usingSpringWithDamping:0.7
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseInOut
    animations:^{
        contentView.frame = categoryRect;
    }completion:^(BOOL completed){
        
    }];
}

- (void)__removeCategoryButtons:(LPAMenuButtonAnimationFinished)block;
{
    __block NSInteger removedCount = 0;
    [_itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        __block UIView *contentView = (UIView *)obj;
        CGRect contentViewRect = contentView.frame;
        contentViewRect.origin.y = CGRectGetHeight(self.window.frame) + CGRectGetHeight(contentViewRect);
        
        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//             usingSpringWithDamping:0.3f
//              initialSpringVelocity:0.8f
//                            options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            contentView.frame = contentViewRect;
        }completion:^(BOOL completed){
            [contentView removeFromSuperview];
            contentView = nil;
            removedCount++;
            if (removedCount == _itemViews.count / 2) {
                if (block) {
                    block(YES);
                }
            }
        }];
    }];
}

#pragma mark - Custom Accessors

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelNormal;
        _window.backgroundColor = [UIColor clearColor];
        _window.hidden = YES;
        _window.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [_window addSubview:self.backgroundView];
        [_window addSubview:self.closeButton];
    }
    return _window;
}

- (UIVisualEffectView *)backgroundView
{
    if (!_backgroundView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _backgroundView.frame = [[UIScreen mainScreen] bounds];
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"╳" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(__closeButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_closeButton setFrame:CGRectMake(CGRectGetWidth(self.window.frame) - 50, 24, 40, 40)];
        [_closeButton setAlpha:0];
    }
    return _closeButton;
}

@end

//--------LPAMenuItem--------//

@interface LPAMenuItem ()

@end

@implementation LPAMenuItem

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
              selectedHandler:(void (^)())handler
{
    LPAMenuItem *item = [[LPAMenuItem alloc] init];
    item.title = title;
    item.image = image;
    item.selectedBlock = handler;
    return item;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], self.title];
}

@end
