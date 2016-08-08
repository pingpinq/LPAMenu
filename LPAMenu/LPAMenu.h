//
//  LPAMenu.h
//  LPAMenu-Demo
//
//  Created by 平果太郎 on 16/8/5.
//  Copyright © 2016年 平果太郎. All rights reserved.
//

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
