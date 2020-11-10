//
//  DBEditViewController.h
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import <UIKit/UIKit.h>
#import "DrawingBoardTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBEditViewController : UIViewController

@property(nonatomic, strong) DrawingBoardTextView *textView;

@property(nonatomic, copy) void(^doneBlock)(UIImage *image,DrawingBoardTextView *textView);

@end

NS_ASSUME_NONNULL_END
