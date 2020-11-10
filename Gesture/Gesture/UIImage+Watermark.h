//
//  UIImage+Watermark.h
//  Watermark
//
//  Created by Alan on 2020/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Watermark)

/// 给图片添加右下角图片水印
- (UIImage *)addWaterImage:(UIImage *)waterImage;

/// 给图片添加右下角文字水印
- (UIImage *)addWatermarkText:(NSString *)text;

/// 给图片添加图片水印
- (UIImage *)addWaterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect;
/**
 
 使用eg:
    //当前屏幕的放缩因子
    CGFloat screenScale = [UIScreen mainScreen].scale;
    UIImage *orinialImage = self.backGroundImageView.image;
 
    CGFloat scale = orinialImage.size.width/self.backGroundImageView.bounds.size.width;
 
    for (NSInteger i = 0; i < self.subDrawingBoardImageViews.count; i ++) {
     
     DrawingBoardImageView *imageView = self.subDrawingBoardImageViews[i];
     CGAffineTransform _trans = imageView.transform;
     CGFloat rotate = acosf(_trans.a);
     // 旋转180度后，需要处理弧度的变化
     if (_trans.b < 0) {
         rotate = M_PI -rotate;
     }
     // 将弧度转换为角度
     CGFloat degree = rotate/M_PI * 180;
     
     /// orinialImage 图片对应的大小 和 屏幕显示的尺寸 和 绘图是尺寸与当前机器放缩因子的关系
     //  waterImage  水印图片
     //   rect       水印图片在原图的范围 和 当前屏幕的放缩因子 （绘制新图片跟当前屏幕有关系）
     //   originalPoint 水印在原图像素的原点
     //  rotateAngle    旋转角度
     orinialImage = [orinialImage addWaterImage:imageView.image waterImageRect:CGRectMake(0, 0, imageView.bounds.size.width * scale/screenScale, imageView.bounds.size.height * scale/screenScale) OriginalPoint:CGPointMake(imageView.frame.origin.x * scale, imageView.frame.origin.y * scale) Rotate:degree];
 
 */
/// 水印 尺寸 旋转角度0~360类型 originalpPoint
- (UIImage *)addWaterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect OriginalPoint:(CGPoint)originalPoint Rotate:(CGFloat)rotateAngle;

/// 给图片添加文字水印 point
- (UIImage *)addWatermarkText:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed;

/// 给图片添加文字水印 rect
- (UIImage *)addWatermarkText:(NSString *)text textRect:(CGRect)rect  attributedString:(NSDictionary * )attributed;


@end

NS_ASSUME_NONNULL_END
