//
//  DrawingBoard.m
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import "DrawingBoard.h"
#import "UIImage+Watermark.h"
#import "DBEditViewController.h"
#import "UIViewController+Utils.h"
@interface DrawingBoard ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) DrawingBoardImageView *backGroundImageView;

@property(nonatomic, strong) DrawingBoardImageView *currentSelector;

/// 手势开始时旋转的角度
@property(nonatomic) CGAffineTransform originalTransformRotate;

/// 手势开始时的size  因为缩放因子是准对原始尺寸的 所以不可以使用前后差值
@property(nonatomic) CGSize originalSize;

/// 开始拖动是 拖动的中心点和 手势中心的差值  = 手势的x,y - 视图的中心点
@property(nonatomic) CGPoint differentPoint;

@property(nonatomic, strong) UIPanGestureRecognizer *pan;

@end

#define defaultSubViewWidth   100.0   //宽高相等

@implementation DrawingBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backGroundImageView = [[DrawingBoardImageView alloc] initWithFrame:self.bounds];
        self.backGroundImageView.clipsToBounds = YES;
        [self addSubview:self.backGroundImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFirstRegist)];
        [self.backGroundImageView addGestureRecognizer:tap];
        
        //pan需要加到指定的子视图上
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.pan.maximumNumberOfTouches = 1;
        self.pan.delegate = self;
        
        //旋转添加父视图操作子视图
        UIRotationGestureRecognizer *rota = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rota:)];
        rota.delegate = self;
        [self.backGroundImageView addGestureRecognizer:rota];
        
        //捏合 添加在父视图上操作
        UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
        pin.delegate = self;
        [self.backGroundImageView addGestureRecognizer:pin];
        
    }
    return self;
}


- (void)setBackGroundImage:(UIImage *)backGroundImage
{
    if (backGroundImage) {
        
        CGSize imageSize = backGroundImage.size;
        if (imageSize.width/imageSize.height >= self.bounds.size.width/self.bounds.size.height) {
            //宽最大 并固定
            CGFloat scale = imageSize.width/self.bounds.size.width;
            CGFloat height = imageSize.height/scale;
            self.backGroundImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
            
        }else{//高最大 并固定
            CGFloat scale = imageSize.height/self.bounds.size.height;
            CGFloat width = imageSize.width/scale;
            self.backGroundImageView.bounds = CGRectMake(0, 0, width, self.bounds.size.height);
        }
        
        self.backGroundImageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        
        self.backGroundImageView.image = backGroundImage;
        
        [self addNewSubView:[UIImage imageNamed:@"1"] TextView:nil];
    }
}

/// 增加新的元素
- (void)addNewSubView:(UIImage *)image TextView:(DrawingBoardTextView *)textView
{
    if (image) {
        
        DrawingBoardImageView *imageView = [[DrawingBoardImageView alloc] initWithFrame:CGRectZero];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        
        CGSize imageSize = image.size;
        if (imageSize.width/imageSize.height >= 1) {
            //宽最大 并固定
            CGFloat scale = imageSize.width/defaultSubViewWidth;
            CGFloat height = imageSize.height/scale;
            imageView.bounds = CGRectMake(0, 0, defaultSubViewWidth, height);
            
        }else{//高最大 并固定
            CGFloat scale = imageSize.height/defaultSubViewWidth;
            CGFloat width = imageSize.width/scale;
            imageView.bounds = CGRectMake(0, 0, width, defaultSubViewWidth);
        }
        
        if (textView) {
            imageView.textView = textView;
        }
        imageView.image = image;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];
        imageView.center = CGPointMake(self.backGroundImageView.bounds.size.width/2.0, self.backGroundImageView.bounds.size.height/2.0);
        [self.backGroundImageView addSubview:imageView];
        [self setFirstRegist:imageView];
        //[self.subDrawingBoardImageViews addObject:imageView];
    }
}


/// 删除元素
- (void)removeSubView:(DrawingBoardImageView *)view
{
    if (view) {
        [self.subDrawingBoardImageViews removeObject:view];
        [self cancelFirstRegist];
        [view removeFromSuperview];
    }
}

/// 设置子视图为当前响应
- (void)setFirstRegist:(DrawingBoardImageView *)view
{
    [self cancelFirstRegist];
    
    self.currentSelector = view;
    [self.currentSelector addGestureRecognizer:self.pan];
    [self.backGroundImageView bringSubviewToFront:self.currentSelector];
    [self.subDrawingBoardImageViews removeObject:view];
    [self.subDrawingBoardImageViews addObject:view];
    
    self.currentSelector.layer.borderWidth = 1;
}

/// 取消子视图当前响应
- (void)cancelFirstRegist
{
    if (self.currentSelector) {
        [self removeGestureRecognizer:self.pan];
        self.currentSelector.layer.borderWidth = 0;
        self.currentSelector = nil;
    }
}

/// 去编辑文本
- (void)goEdit:(DrawingBoardImageView *)drawingBoardImageView
{
    UIViewController *currentVC = [UIViewController currentViewController];
    DBEditViewController *editVC = [[DBEditViewController alloc] init];
    editVC.textView = drawingBoardImageView.textView;
    __weak DrawingBoardImageView *weakDrawingBoardImageView = drawingBoardImageView;
    editVC.doneBlock = ^(UIImage * _Nonnull image, DrawingBoardTextView * _Nonnull textView) {
        
        CGSize imageSize = image.size;
        if (imageSize.width/imageSize.height >= 1) {
            //宽最大 并固定
            CGFloat scale = imageSize.width/defaultSubViewWidth;
            CGFloat height = imageSize.height/scale;
            weakDrawingBoardImageView.bounds = CGRectMake(0, 0, defaultSubViewWidth, height);
            
        }else{//高最大 并固定
            CGFloat scale = imageSize.height/defaultSubViewWidth;
            CGFloat width = imageSize.width/scale;
            weakDrawingBoardImageView.bounds = CGRectMake(0, 0, width, defaultSubViewWidth);
        }
        
        weakDrawingBoardImageView.image = image;
    };
    currentVC.definesPresentationContext = YES;
    editVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [currentVC presentViewController:editVC animated:YES completion:nil];
}

/// 只管理旋转与捏合 拖动 设置了delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    
    if (!self.currentSelector) {
        return NO;
    }else{
        
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            CGPoint centerPoint = [gestureRecognizer locationInView:self.backGroundImageView];
            self.differentPoint = CGPointMake(centerPoint.x - self.currentSelector.center.x, centerPoint.y - self.currentSelector.center.y);
        }
        
        self.originalTransformRotate = self.currentSelector.transform;
        self.originalSize = self.currentSelector.bounds.size;
        return YES;
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    DrawingBoardImageView *view = (DrawingBoardImageView *)tap.view;
    
    //双击进入可编辑
    if (view.textView) {
        if ([view doubleTouch]) {
            ///进入文字编辑  ToDo
            [self goEdit:self.currentSelector];
        }
    }
    
    if (view == self.currentSelector) {
        
    }else{
        [self setFirstRegist:view];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint gesPoint = [pan locationInView:self.backGroundImageView];
    
    if (gesPoint.x >= 0 && gesPoint.x <= self.backGroundImageView.frame.size.width && gesPoint.y >= 0 && gesPoint.y <= self.backGroundImageView.frame.size.height) {
        CGPoint centerPoint = CGPointMake(gesPoint.x - self.differentPoint.x, gesPoint.y - self.differentPoint.y);
        UIView *view = pan.view;
        view.center = centerPoint;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)rota:(UIRotationGestureRecognizer *)rota
{
    CGFloat rotation = rota.rotation;
    self.currentSelector.transform = CGAffineTransformRotate(self.originalTransformRotate, rotation);
}

- (void)pin:(UIPinchGestureRecognizer *)pin
{
    CGFloat scale = pin.scale;
    self.currentSelector.bounds = CGRectMake(0, 0, self.originalSize.width * scale , self.originalSize.height * scale);
}

- (UIImage *)getImage
{
    CGFloat screenScale = [UIScreen mainScreen].scale;
    UIImage *orinialImage = self.backGroundImageView.image;
    
    CGFloat scale = orinialImage.size.width/self.backGroundImageView.bounds.size.width;
    
    for (NSInteger i = 0; i < self.subDrawingBoardImageViews.count; i ++) {
        
        DrawingBoardImageView *imageView = self.subDrawingBoardImageViews[i];
        CGAffineTransform _trans = imageView.transform;
        CGFloat rotate = acosf(_trans.a);
        // 旋转360度后，需要处理弧度的变化
        if (_trans.b < 0) {
            rotate = M_PI * 2 -rotate;
        }
        // 将弧度转换为角度
        CGFloat degree = rotate/(M_PI * 2) * 360;
        
        /// 图片对应的大小 和 屏幕显示的尺寸 和 绘图是尺寸与当前机器放缩因子的关系
        orinialImage = [orinialImage addWaterImage:imageView.image waterImageRect:CGRectMake(0, 0, imageView.bounds.size.width * scale/screenScale, imageView.bounds.size.height * scale/screenScale) OriginalPoint:CGPointMake(imageView.frame.origin.x * scale, imageView.frame.origin.y * scale) Rotate:degree];        
    }
    
    return orinialImage;
}

#pragma mark - initializing
- (NSMutableArray *)subDrawingBoardImageViews
{
    if (!_subDrawingBoardImageViews) {
        _subDrawingBoardImageViews = [[NSMutableArray alloc] init];
    }
    return _subDrawingBoardImageViews;
}

@end
