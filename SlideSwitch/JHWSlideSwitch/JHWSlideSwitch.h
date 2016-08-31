//
//  JHWSlideSwitch.h
//  JHWSlideSwitch
//
//  Copyright © 2016年 JieXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHWSlideSwitchDelegate;

@interface JHWSlideSwitch : UIControl

@property (nonatomic, strong) UIColor *progressColor;/**<轨道线颜色*/
@property (nonatomic, strong) UIColor *titleColor;/**<标题颜色*/
@property (nonatomic, strong) UIColor *titleSelectColor;/**<标题选择颜色，默认跟titleColor一样*/
@property (nonatomic, assign) int selectedIndex;/**<当前选中的indext*/
@property (nonatomic, strong) NSArray *images;/**<滑动按钮的图片/选中图片数组，长度需要跟标题长度一致*/
@property (nonatomic, strong, readonly) UIButton *slideButton;

@property (nonatomic, assign) id<JHWSlideSwitchDelegate> delegate;

-(id) initWithFrame:(CGRect) frame Titles:(NSArray *) titles;

@end

@protocol JHWSlideSwitchDelegate <NSObject>
@optional
/**
 *  选择了某个switch后执行的代理方法
 */
- (void)slideSwitch:(JHWSlideSwitch *)slideSwitch didSelectedAtIndex:(int)index;
/**
 *  拖动到第index个圆圈中心
 */
- (void)slideSwitch:(JHWSlideSwitch *)slideSwitch didDragedAtIndex:(int)index;

@end