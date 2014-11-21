//
//  BSViewController.m
//  BrainStorm
//
//  Created by 杨朋亮 on 20/11/14.
//  Copyright (c) 2014年 daozhu. All rights reserved.
//

#import "BSViewController.h"


static NSInteger kItemViewIndex = 100;

@interface BSViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIButton *btnC;
@property (weak, nonatomic) IBOutlet UIButton *btnD;
@property (weak, nonatomic) IBOutlet UIView *MenuArea;
@property (weak, nonatomic) IBOutlet UIView *actionboard;


@property (strong, nonatomic) NSMutableArray *MenuAreaContents;
@property (strong, nonatomic) NSMutableArray *actionboardContents;

@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    self.actionboard.dropZoneHandler = self;
    
    // Drag drop with long press gesture
//    UIGestureRecognizer *recognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    // Drag drop with pan gesture
    UIGestureRecognizer *recognizer = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
    self.btn.tag = 101;
    [self.btn addGestureRecognizer:recognizer];
    UIGestureRecognizer *recognizerA = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
    self.btnA.tag = 102;
    [self.btnA addGestureRecognizer:recognizerA];
        UIGestureRecognizer *recognizerB = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
    self.btnB.tag = 103;
    [self.btnB addGestureRecognizer:recognizerB];
        UIGestureRecognizer *recognizerC = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
    self.btnC.tag = 104;
    [self.btnC addGestureRecognizer:recognizerC];
        UIGestureRecognizer *recognizerD = [dragDropManager createDragDropGestureRecognizerWithClass:[UIPanGestureRecognizer class] source:self];
    self.btnD.tag = 105;
    [self.btnD addGestureRecognizer:recognizerD];
    
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
    label.text = @"Ovum entered";
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
            label.text = @"Cannot Drop Here";
            
            return OBDropActionNone;
        }
    }
    
    view.layer.borderColor = [UIColor colorWithRed:0.0 green:hiphopopotamus blue:0.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 5.0;
    
    UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
    label.text = [NSString stringWithFormat:@"Ovum at %@", NSStringFromCGPoint(location)];
    
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
    
    if ([ovum.dataObject isKindOfClass:[NSNumber class]])
    {
        UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
        if (itemView)
        {
            [itemView removeFromSuperview];
            [self.MenuAreaContents removeObject:itemView];
            
            NSInteger insertionIndex  = 0;
            [self.actionboard insertSubview:itemView atIndex:insertionIndex];
            [self.actionboardContents insertObject:itemView atIndex:insertionIndex];
            
        }
    }
    else if ([ovum.dataObject isKindOfClass:[UIColor class]])
    {
        // An item from AdditionalSourcesViewController
        UIView *itemView = [self createItemView];
        itemView.backgroundColor = ovum.dataObject;
        NSInteger insertionIndex = 0;
        [self.actionboard insertSubview:itemView atIndex:insertionIndex];
        [self.actionboardContents insertObject:itemView atIndex:insertionIndex];
    }
}

-(UIView *) createItemView
{
    static CGFloat (^randFloat)(CGFloat, CGFloat) = ^(CGFloat min, CGFloat max) { return min + (max-min) * (CGFloat)random() / RAND_MAX; };
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectZero];
    itemView.backgroundColor = [UIColor colorWithHue:randFloat(0.0, 1.0) saturation:randFloat(0.5, 1.0) brightness:randFloat(0.3, 1.0) alpha:1.0];
    itemView.tag = kItemViewIndex++;
    return itemView;
}

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





@end
