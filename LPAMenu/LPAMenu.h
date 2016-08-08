//
//  LPAMenu.h
//  LPAMenu-Demo
//
//  Created by 平果太郎 on 16/8/5.
//  Copyright © 2016年 平果太郎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "LPAMenuItem.h"

//--------LPAMenu--------//
@protocol LPAMenuDelegate;
@class LPAMenuItem;
@interface LPAMenu : NSObject

@property (nonatomic, assign) NSUInteger cellMaxCount;
@property (nonatomic, weak) id<LPAMenuDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray<LPAMenuItem *> *items;

- (instancetype)initWithMenuItems:(NSArray<LPAMenuItem *> *)menuItems;

- (void)addMenuItem:(LPAMenuItem *)menuItem;
- (void)addMenuItems:(NSArray<LPAMenuItem *> *)menuItems;

- (void)show;
- (void)dismiss;

@end

@protocol LPAMenuDelegate <NSObject>

@optional

- (void)lpaMenuDidDismiss:(LPAMenu *)menu;

@end

//--------LPAMenuItem--------//
typedef void(^LPAMenuSelectBlock)();
@interface LPAMenuItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, copy) NSArray  *subItem;
@property(nonatomic, copy) LPAMenuSelectBlock selectedBlock;

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedHandler:(void(^)())handler;

@end
