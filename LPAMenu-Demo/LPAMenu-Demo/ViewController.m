//
//  ViewController.m
//  LPAMenu-Demo
//
//  Created by 平果太郎 on 16/8/5.
//  Copyright © 2016年 平果太郎. All rights reserved.
//

#import "ViewController.h"
#import "LPAMenu.h"

@interface ViewController () <LPAMenuDelegate>

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"LPAMenu Demo";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (IBAction)showButtonHandler:(UIButton *)sender
{
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
}

#pragma mark - LPAMenu Delegate

- (void)lpaMenu:(LPAMenu *)menu didSelectedAtIndex:(NSInteger)index
{
    LPAMenuItem *menuItem = menu.items[index];
    NSLog(@"%@->%@", NSStringFromSelector(_cmd), menuItem);
}

- (void)lpaMenuDidDismiss:(LPAMenu *)menu
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
