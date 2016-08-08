//
//  ViewController.m
//  LPAMenu-Demo
//
//  Created by 平果太郎 on 16/8/5.
//  Copyright © 2016年 平果太郎. All rights reserved.
//

#import "ViewController.h"
#import "LPAMenu.h"

@interface ViewController ()

@property (nonatomic, strong) LPAMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"LPAMenu Demo";
    self.menu = [[LPAMenu alloc] init];
    self.menu.cellMaxCount = 2;
    
    LPAMenuItem *item1 = [LPAMenuItem itemWithTitle:@"item1" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil];
    LPAMenuItem *item2 = [LPAMenuItem itemWithTitle:@"item2" image:[UIImage imageNamed:@"icon_catetory_game"] selectedHandler:nil];
    LPAMenuItem *item3 = [LPAMenuItem itemWithTitle:@"item3" image:[UIImage imageNamed:@"icon_catetory_life"] selectedHandler:nil];
    LPAMenuItem *item4 = [LPAMenuItem itemWithTitle:@"item4" image:[UIImage imageNamed:@"icon_catetory_message"] selectedHandler:nil];
    LPAMenuItem *item5 = [LPAMenuItem itemWithTitle:@"item5" image:[UIImage imageNamed:@"icon_catetory_application"] selectedHandler:nil];
    [self.menu addMenuItems:@[item1,
                              item2,
                              item3,
                              item4,
                              item5]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showButtonHandler:(UIButton *)sender
{
    [_menu show];
}

@end
