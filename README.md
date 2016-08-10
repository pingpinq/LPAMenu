# LPAMenu
A beautiful full screen category menu for iOS.

# Overview

![snapshot](https://github.com/leeping610/LPAMenu/blob/master/demo_1.gif)
![snapshot](https://github.com/leeping610/LPAMenu/blob/master/demo_2.gif)

Require at least iOS **8.0**.

# Usage

``` objc
#import "LPAMenu.h"

LPAMenu *menu = [[LPAMenu alloc] init];
    menu.cellMaxCount = 2;
    menu.delegate = self;
    
    LPAMenuItem *item1 = [LPAMenuItem itemWithTitle:@"item1"
                                              image:[UIImage imageNamed:@"icon_catetory_application"]
    selectedHandler:^{
        NSLog(@"item1 selected");
    }];
    LPAMenuItem *item2 = [LPAMenuItem itemWithTitle:@"item2" image:[UIImage imageNamed:@"icon_catetory_game"] selectedHandler:nil];
    LPAMenuItem *item3 = [LPAMenuItem itemWithTitle:@"item3" image:[UIImage imageNamed:@"icon_catetory_life"] selectedHandler:nil];
    LPAMenuItem *item4 = [LPAMenuItem itemWithTitle:@"item4" image:[UIImage imageNamed:@"icon_catetory_message"] selectedHandler:nil];
    LPAMenuItem *item5 = [LPAMenuItem itemWithTitle:@"item5" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil];
    item5.subItem = @[[LPAMenuItem itemWithTitle:@"subItem1" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil],
                      [LPAMenuItem itemWithTitle:@"subItem1" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil],
                      [LPAMenuItem itemWithTitle:@"subItem1" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil]];
    [menu addMenuItems:@[item1, item2, item3, item4, item5]];
    [menu show];
```

#Installation

add LPAMenu.h/m to your project

# License
MIT
