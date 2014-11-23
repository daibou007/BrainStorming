//
//  BSViewController.m
//  BrainStorm
//
//  Created by 杨朋亮 on 20/11/14.
//  Copyright (c) 2014年 daozhu. All rights reserved.
//

#import "BSViewController.h"


static NSInteger kItemViewBaseTag = 100;



@interface BSViewController ()


@property (strong,nonatomic) NSMutableArray *menuArrays;


@property (weak, nonatomic) IBOutlet UIScrollView *MenuArea;
@property (weak, nonatomic) IBOutlet UIView *actionboard;


//@property (strong, nonatomic) NSMutableArray *MenuAreaContents;
@property (strong, nonatomic) NSMutableArray *actionboardContents;

@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuArrays = [[NSMutableArray alloc] init];
    
    OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    self.actionboard.dropZoneHandler = self;
    
    // Drag drop with long press gesture
//    UIGestureRecognizer *recognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    // Drag drop with pan gesture
    UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
//    self.btn.tag = 101;
//    [self.btn addGestureRecognizer:recognizer];
//    UIGestureRecognizer *recognizerA = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
//    self.btnA.tag = 102;
//    [self.btnA addGestureRecognizer:recognizerA];
//        UIGestureRecognizer *recognizerB = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
//    self.btnB.tag = 103;
//    [self.btnB addGestureRecognizer:recognizerB];
//        UIGestureRecognizer *recognizerC = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
//    self.btnC.tag = 104;
//    [self.btnC addGestureRecognizer:recognizerC];
//        UIGestureRecognizer *recognizerD = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
//    self.btnD.tag = 105;
//    [self.btnD addGestureRecognizer:recognizerD];
    
}


#pragma mark - OBOvumSource

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
    OBOvum *ovum = [[OBOvum alloc] init];
    ovum.dataObject = [NSNumber numberWithInteger:sourceView.tag];
    return ovum;
}


-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
    CGRect frame = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
    frame = [window convertRect:frame fromWindow:sourceView.window];
    
    frame.size.width = frame.size.width*0.9;
    frame.size.height = frame.size.height*0.9;
    frame.origin.x = frame.origin.x *1.1;
    frame.origin.y = frame.origin.y *1.1;
    
    UIView *dragView = [[UIView alloc] initWithFrame:frame];
    dragView.backgroundColor = sourceView.backgroundColor;
    dragView.layer.cornerRadius = 5.0;
    dragView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    dragView.layer.borderWidth = 1.0;
    dragView.layer.masksToBounds = YES;
    return dragView;
}


-(void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
    dragView.transform = CGAffineTransformIdentity;
    dragView.alpha = 0.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        dragView.center = location;
        dragView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        dragView.alpha = 0.75;
    }];
}



#pragma mark - OBDropZone

static NSInteger kLabelTag = 2323;

-(OBDropAction) ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Entered", (int)ovum, ovum.dataObject);
    
    CGFloat red = 0.33 + 0.66 * location.y / self.view.frame.size.height;
    view.layer.borderColor = [UIColor colorWithRed:red green:0.0 blue:0.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 5.0;
    
    CGRect labelFrame = CGRectMake(ovum.dragView.bounds.origin.x, ovum.dragView.bounds.origin.y, ovum.dragView.bounds.size.width, ovum.dragView.bounds.size.height / 2);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
    label.text = ((UIButton*)itemView).titleLabel.text;
    
    label.tag = kLabelTag;
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [ovum.dragView addSubview:label];
    
    return OBDropActionMove;
}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    //  NSLog(@"Ovum<0x%x> %@ Moved", (int)ovum, ovum.dataObject);
    
    CGFloat hiphopopotamus = 0.33 + 0.66 * location.y / self.view.frame.size.height;
    
    // This tester currently only supports dragging from left to right view
    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
    {
        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
        if ([self.actionboardContents containsObject:itemView])
        {
            view.layer.borderColor = [UIColor colorWithRed:hiphopopotamus green:0.0 blue:0.0 alpha:1.0].CGColor;
            view.layer.borderWidth = 5.0;
            
            UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
            
            UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
            label.text = ((UIButton*)itemView).titleLabel.text;
            
            return OBDropActionNone;
        }
    }
    
    view.layer.borderColor = [UIColor colorWithRed:0.0 green:hiphopopotamus blue:0.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 5.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    
    UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
    label.text = ((UIButton*)itemView).titleLabel.text;
    
    return OBDropActionMove;
}

-(void) ovumExited:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Exited", (int)ovum, ovum.dataObject);
    
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    [label removeFromSuperview];
}

-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSLog(@"Ovum<0x%x> %@ Dropped", (int)ovum, ovum.dataObject);
    
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    [label removeFromSuperview];
    
    ovum.dragView.width = 100;
    ovum.dragView.height = 60;
    
    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
    {
        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
        if (itemView)
        {
            [itemView removeFromSuperview];
            [self.menuArrays removeObject:itemView];
            [self pushScrollViewSubViews:(itemView.tag - kItemViewBaseTag)];
            
            NSInteger insertionIndex  = 0;
            [self.actionboard insertSubview:itemView atIndex:insertionIndex];
            [self.actionboardContents insertObject:itemView atIndex:insertionIndex];
            
        }
    }

}

//-(UIView *) createItemView
//{
//    static CGFloat (^randFloat)(CGFloat, CGFloat) = ^(CGFloat min, CGFloat max) { return min + (max-min) * (CGFloat)random() / RAND_MAX; };
//    UIView *itemView = [[UIView alloc] initWithFrame:CGRectZero];
//    itemView.backgroundColor = [UIColor colorWithHue:randFloat(0.0, 1.0) saturation:randFloat(0.5, 1.0) brightness:randFloat(0.3, 1.0) alpha:1.0];
//    itemView.tag = kItemViewIndex++;
//    return itemView;
//}

-(void) handleDropAnimationForOvum:(OBOvum*)ovum withDragView:(UIView*)dragView dragDropManager:(OBDragDropManager*)dragDropManager
{
    UIView *itemView = nil;
    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
        itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
    else if ([ovum.dataObject isKindOfClass:[UIColor class]])
        itemView = [self.actionboardContents lastObject];
    
    if (itemView)
    {
        // Set the initial position of the view to match that of the drag view
        CGRect dragViewFrameInTargetWindow = [ovum.dragView.window convertRect:dragView.frame toWindow:self.actionboard.window];
        dragViewFrameInTargetWindow = [self.actionboard convertRect:dragViewFrameInTargetWindow fromView:self.actionboard.window];
        itemView.frame = dragViewFrameInTargetWindow;
        
        CGRect viewFrame = [ovum.dragView.window convertRect:itemView.frame fromView:itemView.superview];
        
        void (^animation)() = ^{
            dragView.frame = viewFrame;
            
//            [self layoutScrollView:self.MenuArea withContents:self.MenuAreaContents];
//            [self layoutScrollView:self.actionboard withContents:self.actionboardContents];
        };
        
        [dragDropManager animateOvumDrop:ovum withAnimation:animation completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ACtion

-(IBAction) radomActon:(id)sender{
    
    OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    
     NSArray *LabelDB = @[@"移动互联网",@"互联网资讯", @"智能手机", @"移动操作系统", @"移动应用", @"苹果", @"iphone", @"三星", @"移动平台", @"android", @"平板电脑", @"配置", @"微软", @"windows phone", @"诺基亚", @"ios", @"谷歌", @"4G网络", @"htc", @"运营商", @"智能手表", @"市场", @"ipad", @"移动", @"LG", @"应用商店", @"魅族", @"摩托罗拉", @"手机操作系统", @"小米", @"windows", @"Galaxy", @"索尼", @"黑莓", @"小米手机", @"互联网", @"华为", @"联想", @"微信", @"Lumia"];
    
    NSUInteger count = arc4random()%5 + 1;
    NSUInteger index = 0;
    
    for (int i = 0; i<count; i++) {
       index = arc4random()%[LabelDB count];
        UIButton *btn =  [self createMenuButtonByname:[LabelDB objectAtIndex:index]];
        
        UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
        btn.tag = kItemViewBaseTag + i;
        
        [btn addGestureRecognizer:recognizer];
        [self.menuArrays addObject:btn];
    }

    if (self.MenuArea) {
        [self.MenuArea clear];
    }
    
    CGFloat contentWidth = 10.0f;
    
    for (UIButton *btn in self.menuArrays) {
        btn.x = contentWidth;
        btn.y = (self.MenuArea.height - btn.height)/2;
        [self.MenuArea addSubview:btn];
        contentWidth += btn.width + 10;
    }
    
    [self.MenuArea setContentSize:CGSizeMake(contentWidth+10, 0)];
    [self.MenuArea setContentOffset:CGPointZero];
    
}

-(void)pushScrollViewSubViews:(int)tag{
    CGFloat contentWidth = 10.0f;
    if([self.menuArrays count] > 0){
        for (UIView * view in self.menuArrays) {
            if (view.tag   >  tag + kItemViewBaseTag) {
                view.x -= 100;
            }
        }
        contentWidth += 100 +10;
    }
    [self.MenuArea setContentSize:CGSizeMake(contentWidth+10, 0)];
    [self.MenuArea setContentOffset:CGPointZero];
}


-(UIButton*) createMenuButtonByname:(NSString*)str{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [btn setBackgroundColor:RGBCOLOR(17, 124,255)];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(244,244,244) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(15,15,15) forState:UIControlStateHighlighted];

    return btn;
}



@end
