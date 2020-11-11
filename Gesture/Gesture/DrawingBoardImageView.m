//
//  DrawingBoardImageView.m
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import "DrawingBoardImageView.h"

@interface DrawingBoardImageView ()

@property(nonatomic, assign) double lastTime;//上次点击的时间戳

@end

@implementation DrawingBoardImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (BOOL)doubleTouch
{
    double time = [self getTime];
    
    if (time - self.lastTime < 1000) {
        //本次有效 并归零
        self.lastTime = 0;
        return YES;
    }
    
    self.lastTime = time;
    return NO;
}

- (double)getTime
{
    NSDate* date = [NSDate date];
    NSTimeInterval time= [date timeIntervalSince1970] * 1000; // *1000 是精确到毫秒，不乘就是精确到秒
    //NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return time;
}


@end
