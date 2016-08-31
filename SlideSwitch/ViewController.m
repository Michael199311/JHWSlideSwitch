//
//  ViewController.m
//  JWHSlideSwitch
//  测试一下
//  Copyright © 2016年 Codger. All rights reserved.
//

#import "ViewController.h"
#import "JHWSlideSwitch.h"

@interface ViewController ()<JHWSlideSwitchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JHWSlideSwitch *slideSwitch = [[JHWSlideSwitch alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width) Titles:@[@"方式一",@"方式二",@"方式三"]];
    slideSwitch.images =  @[@{@"normal":[UIImage imageNamed:@"分时租原型"],@"highlighted":[UIImage imageNamed:@"分时租移动时候交互"]},
                            @{@"normal":[UIImage imageNamed:@"日租原型"], @"highlighted":[UIImage imageNamed:@"日租移动时候交互"]},
                            @{@"normal":[UIImage imageNamed:@"夜租原型"], @"highlighted":[UIImage imageNamed:@"夜租移动时候交互"]}];
    slideSwitch.selectedIndex = 0;
    [slideSwitch setProgressColor:[UIColor groupTableViewBackgroundColor]];
    [slideSwitch setTitleColor:[UIColor blackColor]];
    [slideSwitch setTitleSelectColor:[UIColor blackColor]];
    slideSwitch.delegate = self;
    [self.view addSubview:slideSwitch];
}

#pragma mark - JHWSlideSwitchDelegate

- (void)slideSwitch:(JHWSlideSwitch *)slideSwitch didDragedAtIndex:(int)index{
    NSLog(@"选中了第%d个区间",index);
}

- (void)slideSwitch:(JHWSlideSwitch *)slideSwitch didSelectedAtIndex:(int)index{
    NSLog(@"移动到了第%d个区间",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
