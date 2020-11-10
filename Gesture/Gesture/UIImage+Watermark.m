//
//  UIImage+Watermark.m
//  Watermark
//
//  Created by Alan on 2020/11/6.
//

#import "UIImage+Watermark.h"

@implementation UIImage (Watermark)

// 给图片添加右下角图片水印
- (UIImage *)addWaterImage:(UIImage *)waterImage
{
    CGFloat scale = 0.3;
    CGFloat margin = 20;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = self.size.width - waterW - margin;
    CGFloat waterY = self.size.height - waterH - margin;
    
    UIImage *image = [self addWaterImage:waterImage waterImageRect:CGRectMake(waterX, waterY, waterW, waterH)];
    return image;
}

// 给图片添加右下角文字水印
- (UIImage *)addWatermarkText:(NSString *)text
{
    CGFloat margin = 5;
    CGFloat waterW = 150;
    CGFloat waterH = 30;
    CGFloat waterX = self.size.width - waterW - margin;
    CGFloat waterY = self.size.height - waterH - margin;
    
    UIImage *image = [self addWatermarkText:text textRect:CGRectMake(waterX, waterY, waterW, waterH) attributedString:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    return image;
}

// 给图片添加图片水印
- (UIImage *)addWaterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect
{
    if (!waterImage) {
        return self;
    }
    
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //3.绘制背景图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

//水印 尺寸 旋转角度 originalpPoint
- (UIImage *)addWaterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect OriginalPoint:(CGPoint)originalPoint Rotate:(CGFloat)rotateAngle
{
    if (!waterImage) {
        return self;
    }
            
    waterImage = [waterImage rotateImageWithAngle:rotateAngle ImageBounds:rect];
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //3.绘制背景图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawAtPoint:originalPoint blendMode:kCGBlendModeNormal alpha:1];
    //[waterImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

// 给图片添加文字水印 point
- (UIImage *)addWatermarkText:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed
{
    if (!text) {
        return self;
    }
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

// 给图片添加文字水印 rect
- (UIImage *)addWatermarkText:(NSString *)text textRect:(CGRect)rect  attributedString:(NSDictionary * )attributed
{
    if (!text) {
        return self;
    }
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //添加水印文字
    [text drawInRect:rect withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

///根据显示尺寸 生成对应像素的图片
- (UIImage *)rotateImageWithAngle:(CGFloat)angle ImageBounds:(CGRect)rect
{
    CGFloat rotation = angle * M_PI/180.0;

    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    //根据屏幕scale 生成对应的图片大小 （因为要通过centerPoint 去设置，所有像素对应尺寸很重要
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // 我们的绘图空间的旋转视图的包含框的大小 画布的大小
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,width * scale,height * scale)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotation);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // 创建位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rotatedSize.width, rotatedSize.height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context,1.0,48/255.0,48/255.0,1.0);
//    CGContextFillRect(context,CGRectMake(0, 0, rotatedSize.width, rotatedSize.height));
//    CGContextSaveGState(context);
    
    // 将原点移动到图像中间，这样我们就可以在中心周围旋转和旋转。
    CGContextTranslateCTM(context, rotatedSize.width/2.0, rotatedSize.height/2.0);
    
    //旋转图像上下文
    CGContextRotateCTM(context, rotation);
    
    //现在，将旋转/缩放的图像绘制到上下文中
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-width * scale/2.0, -height * scale/2.0, width * scale, height * scale), [self CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
