//
//  DrawingBoard.h
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import <UIKit/UIKit.h>
#import "DrawingBoardImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DrawingBoard : UIView

@property(nonatomic, strong) NSMutableArray *subDrawingBoardImageViews;

/// 设置背景图片
- (void)setBackGroundImage:(UIImage *)backGroundImage;

/// 增加新的元素
- (void)addNewSubView:(UIImage *)image TextView:(DrawingBoardTextView *)textView;

/// 获取绘制的图片
- (UIImage *)getImage;

@end

NS_ASSUME_NONNULL_END
