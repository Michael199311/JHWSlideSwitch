//
//  JHWSlideSwitch.m
//  JHWSlideSwitch
//
//  Copyright © 2016年 JieXing. All rights reserved.
//

#import "JHWSlideSwitch.h"
#import <math.h>

#define LEFT_OFFSET 20 /**<轨道左边距*/
#define RIGHT_OFFSET 20 /**<轨道右边距*/
#define TOP_OFFSET 32.5 /**<轨道top to super view bottom的边距*/
#define TITLE_SELECTED_DISTANCE 9 /**<选中时标题和圆圈的距离*/

@interface JHWSlideSwitch ()
{
	NSArray *titleArray;
	CGPoint offsetPoint;
}

@property (nonatomic, strong) UIButton *slideButton;

@end

@implementation JHWSlideSwitch
//@dynamic slideButton;

-(id) initWithFrame:(CGRect) frame Titles:(NSArray *) titles
{
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 70)]) {
		[self setBackgroundColor:[UIColor clearColor]];
		titleArray = [[NSArray alloc] initWithArray:titles];
		[self setProgressColor:[UIColor colorWithRed:103/255.f green:173/255.f blue:202/255.f alpha:1]];
		[self setTitleColor:[UIColor colorWithRed:103/255.f green:173/255.f blue:202/255.f alpha:1]];
        [self setTitleSelectColor:self.titleColor];		//添加标题
		[self addTitleLabel];
		//添加滑动按钮
		[self addSlideButton];
		
		//添加点击手势
		UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ItemSelected:)];
		[self addGestureRecognizer:gest];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	NSAssert(titleArray.count > 0, @"选项数量必须大于1");
	//获取画板
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	/*绘制矩形轨道*/
	//矩形填充色
	CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
	//矩形布局
	CGContextFillRect(context, CGRectMake(LEFT_OFFSET, rect.size.height - TOP_OFFSET, rect.size.width - LEFT_OFFSET - RIGHT_OFFSET, 5.0f));
	//保存
	CGContextSaveGState(context);
	
	/*绘制矩形轨道上边框*/
	CGColorRef shadowColor = [UIColor colorWithRed:0 green:0
											  blue:0 alpha:.9f].CGColor;
	CGColorRef shadowStrokeColor = [UIColor colorWithRed:0 green:0
													blue:0 alpha:.2f].CGColor;
	CGContextSetShadowWithColor(context, CGSizeMake(0, 1.0f), 2.0f, shadowColor);
	CGContextSetStrokeColorWithColor(context, shadowStrokeColor);
	CGContextSetLineWidth(context, 0.4f);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, LEFT_OFFSET, rect.size.height - TOP_OFFSET);
	CGContextAddLineToPoint(context, rect.size.width - RIGHT_OFFSET, rect.size.height - TOP_OFFSET);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
	CGContextSaveGState(context);
	
	/*绘制矩形轨道下边框*/
	CGContextSetStrokeColorWithColor(context, shadowStrokeColor);
	CGContextSetLineWidth(context, 0.4f);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, LEFT_OFFSET, rect.size.height - TOP_OFFSET + 5);
	CGContextAddLineToPoint(context, rect.size.width - RIGHT_OFFSET, rect.size.height - TOP_OFFSET + 5);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
	
	//绘制圆圈
	CGPoint centerPoint;//圆圈中心位置
	for (int i = 0; i < titleArray.count; i++) {
		centerPoint = [self getCenterPointForIndex:i];
		//矩形上填充圆形
		CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
		CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x-10, rect.size.height-38.0f, 15, 15));
		
		//小圆圈的上半部分圆弧
		
		CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
																   blue:0 alpha:.2f].CGColor);
		CGContextSetLineWidth(context, .4f);
		CGContextAddArc(context,centerPoint.x-2.0,rect.size.height-30.5f,7.0f,18*M_PI/180,165*M_PI/180,0);
		CGContextDrawPath(context,kCGPathStroke);
		
		//小圆圈的下半部分圆弧
		
		CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0
																   blue:0 alpha:.2f].CGColor);
		
		CGContextAddArc(context,centerPoint.x-2.0,rect.size.height-30.5f,7.0f,(i==titleArray.count-1?18:-14)*M_PI/180,(i==0?-198:-170)*M_PI/180,1);
		CGContextSetLineWidth(context, .4f);
		CGContextDrawPath(context,kCGPathStroke);
	}
	
//	CGFloat radius = 7.5f;
//	CGFloat rectHeight = 5.0f;
//	CGFloat startPointX = LEFT_OFFSET + radius;
//	CGFloat startPointY = (CGRectGetHeight(rect) - TOP_OFFSET) + rectHeight / 2.0;
//	//求出弧度角,根据弧度角计算startAngle和endAngle
//	double arcAngle = asin((rectHeight / 2) / radius);
//	for (int i = 0; i < titleArray.count; i++) {
//		
//	}
}

#pragma mark - events 
-(void) ItemSelected:(UITapGestureRecognizer *)tap
{
	self.selectedIndex = [self getSelectedIndexInTouchPoint:[tap locationInView:self]];
}

- (void)TouchDown:(UIButton *)btn withEvent:(UIEvent *)event
{
	//btn.highlighted = YES;
	CGPoint currPoint = [[[event allTouches] anyObject] locationInView:self];
	offsetPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
}

-(void)TouchUp:(UIButton*) btn
{
	//btn.highlighted = NO;
	self.selectedIndex = [self getSelectedIndexInTouchPoint:btn.center];
}

- (void)TouchMove:(UIButton *)btn withEvent:(UIEvent *)event
{
    btn.selected = NO;
	CGPoint currPoint = [[[event allTouches] anyObject] locationInView:self];
	CGPoint toPoint = CGPointMake(currPoint.x-offsetPoint.x, self.slideButton.frame.origin.y);
	toPoint = [self fixFinalPoint:toPoint];
	[self.slideButton setFrame:CGRectMake(toPoint.x, toPoint.y, self.slideButton.frame.size.width, self.slideButton.frame.size.height)];
	
	int currentIndex = [self getSelectedIndexInTouchPoint:self.slideButton.center];
	[self animateTitlesToIndex:currentIndex];
	
	BOOL isCenter = [self isCenterInIndex:currentIndex point:btn.center];
	if (isCenter) {
		[self setSlideButtonImage:currentIndex];
		if ([self.delegate respondsToSelector:@selector(slideSwitch:didDragedAtIndex:)]) {
			[self.delegate slideSwitch:self didDragedAtIndex:currentIndex];
		}
	}
}


#pragma mark - private method
- (void)addTitleLabel
{
	NSString *title;
	//添加标题
	for (int i = 0; i < titleArray.count; i++) {
		title = titleArray[i];
		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, [self getSlotWidth], 10)];
		[titleLabel setText:title];
		[titleLabel setFont:[UIFont systemFontOfSize:10]];
		[titleLabel setTextColor:[UIColor blackColor]];
		[titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
		[titleLabel setAdjustsFontSizeToFitWidth:YES];
		[titleLabel setTextAlignment:NSTextAlignmentCenter];
		[titleLabel setShadowOffset:CGSizeMake(0, 1)];
		titleLabel.tag = i + 50;
		CGPoint center = [self getCenterPointForIndex:i];
		if (i == 0) {
			center.y -= TITLE_SELECTED_DISTANCE;
		}
		titleLabel.center = center;
		[self addSubview:titleLabel];
	}
}

- (void)addSlideButton
{
	self.slideButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.slideButton setFrame:CGRectMake(LEFT_OFFSET, 8, 45, 45)];
	[self.slideButton setAdjustsImageWhenHighlighted:NO];
	[self.slideButton setCenter:CGPointMake(LEFT_OFFSET, self.frame.size.height-29.5f)];
	[self addSubview:self.slideButton];
	self.slideButton.backgroundColor = [UIColor clearColor];
	//按下事件
	[self.slideButton addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
	//抬起事件，包括按钮内抬起和按钮外抬起，这个一般是跟在UIControlEventTouchDown事件后
	[self.slideButton addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
	//拖动事件
	[self.slideButton addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
}

- (BOOL)isCenterInIndex:(int)index point:(CGPoint)point
{
	CGPoint center = [self getCenterPointForIndex:index];
	CGFloat offset = center.x - point.x;
	if (fabs(offset) < 5) {
		//中心点位置作用两个像素，可以看做是重叠了
		return YES;
	}
	return NO;
}
/**
 *  获取第index个圆圈的中心点
 */
- (CGPoint)getCenterPointForIndex:(int)index
{
	CGFloat x = (index * (CGRectGetWidth(self.frame) - LEFT_OFFSET - RIGHT_OFFSET) / (titleArray.count - 1)) + LEFT_OFFSET;
	CGFloat y = CGRectGetHeight(self.frame) - 55.0f;
	return CGPointMake(x, y);
}

/**
 *  根据触摸点计算当前点击的index
 */
- (int)getSelectedIndexInTouchPoint:(CGPoint)touchPoint
{
	CGFloat slotWidth = [self getSlotWidth];
	return round((touchPoint.x - LEFT_OFFSET) / slotWidth);
}
/**
 *  根据titleArray的数量计算每个圆圈的课点击范围
 */
- (CGFloat)getSlotWidth
{
	return (CGRectGetWidth(self.frame) - LEFT_OFFSET - RIGHT_OFFSET) / (titleArray.count - 1);
}
/**
 *  计算左右边界值
 */
-(CGPoint)fixFinalPoint:(CGPoint)buttonPoint
{
	if (buttonPoint.x < LEFT_OFFSET-(CGRectGetWidth(self.slideButton.frame)/2.f)) {
		buttonPoint.x = LEFT_OFFSET-(CGRectGetWidth(self.slideButton.frame)/2.f);
	}else if (buttonPoint.x+(CGRectGetWidth(self.slideButton.frame)/2.f) > self.frame.size.width-RIGHT_OFFSET){
		buttonPoint.x = self.frame.size.width-RIGHT_OFFSET- (CGRectGetWidth(self.slideButton.frame)/2.f);
	}
	return buttonPoint;
}

-(void)animateTitlesToIndex:(int)index
{
	int i;
	UILabel *lbl;
	for (i = 0; i < titleArray.count; i++) {
		lbl = (UILabel *)[self viewWithTag:i+50];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		if (i == index) {
			//选中时label颜色
			[lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-55-TITLE_SELECTED_DISTANCE)];
			[lbl setTextColor: self.titleColor];
			[lbl setAlpha:1];
		}else{
			//未选中时label颜色
			[lbl setCenter:CGPointMake(lbl.center.x, self.frame.size.height-55)];
			[lbl setTextColor:self.titleSelectColor];
			[lbl setAlpha:1];
		}
		[UIView commitAnimations];
	}
}

-(void)animateHandlerToIndex:(int)index
{
	CGPoint toPoint = [self getCenterPointForIndex:index];
	toPoint = CGPointMake(toPoint.x-(CGRectGetWidth(self.slideButton.frame)/2.f), CGRectGetMinY(self.slideButton.frame));
	toPoint = [self fixFinalPoint:toPoint];
	
	[UIView beginAnimations:nil context:nil];
	[self.slideButton setFrame:CGRectMake(toPoint.x, toPoint.y, CGRectGetWidth(self.slideButton.frame), CGRectGetHeight(self.slideButton.frame))];
	[UIView commitAnimations];
}

- (void)setSlideButtonImage:(int)index
{
	if (self.images.count > 0) {
		NSDictionary *imageDictionary = self.images[index];
		UIImage *normalImage = imageDictionary[@"normal"];
		UIImage *highlightedImage = imageDictionary[@"highlighted"];
		[self.slideButton setImage:normalImage forState:UIControlStateNormal];
		[self.slideButton setImage:highlightedImage forState:UIControlStateHighlighted];
	}
}


#pragma mark - setters and getters
- (void)setSelectedIndex:(int)selectedIndex
{
	_selectedIndex = selectedIndex;
	[self animateTitlesToIndex:selectedIndex];
	[self animateHandlerToIndex:selectedIndex];
	[self setSlideButtonImage:selectedIndex];
	if ([self.delegate respondsToSelector:@selector(slideSwitch:didSelectedAtIndex:)]) {
		[self.delegate slideSwitch:self didSelectedAtIndex:selectedIndex];
	}
}

- (void)setImages:(NSArray *)images
{
	NSAssert(images.count == titleArray.count, @"图片数组长度需要和标题数组长度一致");
	_images = images;
	//设置默认图片
	[self setSlideButtonImage:0];
}

@end
