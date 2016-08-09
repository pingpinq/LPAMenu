//
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//--------LPAMenu--------//
@protocol LPAMenuDelegate;
@class LPAMenuItem;
@interface LPAMenu : NSObject

// The max count of a row
@property (nonatomic, assign) NSUInteger cellMaxCount;
@property (nonatomic, weak) id<LPAMenuDelegate> delegate;
// Menu icons
@property (nonatomic, strong, readonly) NSArray<LPAMenuItem *> *items;

/**
 *  Init with menu icons array
 */
- (instancetype)initWithMenuItems:(NSArray<LPAMenuItem *> *)menuItems;
/**
 *  Add a menu icon to menu
 */
- (void)addMenuItem:(LPAMenuItem *)menuItem;
/**
 *  Add mutiple menu icons to menu
 */
- (void)addMenuItems:(NSArray<LPAMenuItem *> *)menuItems;
/**
 *  Show the LPAMenu
 */
- (void)show;
/**
 *  Dismiss the LPAMenu
 */
- (void)dismiss;

@end

@protocol LPAMenuDelegate <NSObject>
@optional
// Callback when menu dismissed
- (void)lpaMenuDidDismiss:(LPAMenu *)menu;
// Callback when menu icon pressed
- (void)lpaMenu:(LPAMenu *)menu didSelectedAtIndex:(NSInteger)index;
@end

//--------LPAMenuItem--------//
typedef void(^LPAMenuSelectBlock)();
@interface LPAMenuItem : NSObject

@property(nonatomic, copy) NSString *title;     // the title of menu icon
@property(nonatomic, strong) UIImage *image;    // the image if menu icon
@property(nonatomic, copy) NSArray  *subItem;   // if this menu icon has sub menu icon
@property(nonatomic, copy) LPAMenuSelectBlock selectedBlock; // callback when menu icon pressed

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedHandler:(void(^)())handler;

@end
