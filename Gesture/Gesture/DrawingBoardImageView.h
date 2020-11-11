//
//  DrawingBoardImageView.h
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import <UIKit/UIKit.h>
#import "DrawingBoardTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DrawingBoardImageView : UIImageView

@property(nonatomic, strong) DrawingBoardTextView *textView;

- (BOOL)doubleTouch;

@end

NS_ASSUME_NONNULL_END
