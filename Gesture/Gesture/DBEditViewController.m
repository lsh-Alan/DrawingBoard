//
//  DBEditViewController.m
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import "DBEditViewController.h"

@interface DBEditViewController ()<UITextViewDelegate>

@end

@implementation DBEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    if (!self.textView) {
        CGFloat width = self.view.bounds.size.width;
        self.textView = [[DrawingBoardTextView alloc] initWithFrame:CGRectMake(15, 200, width - 30, 40)];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.delegate = self;
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.tintColor = [UIColor blackColor];
        self.textView.returnKeyType = UIReturnKeyDone;
        
        
        
        //字体阴影
//        //阴影透明度
//        self.textView.layer.shadowOpacity = 1.0;
//            //阴影宽度
//        self.textView.layer.shadowRadius = 21.0;
//            //阴影颜色
//        self.textView.layer.shadowColor = [UIColor whiteColor].CGColor;
//            //映影偏移
//        self.textView.layer.shadowOffset = CGSizeMake(0, 0);
        
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = 20.0;
        shadow.shadowOffset = CGSizeMake(0, 0);
        shadow.shadowColor = [UIColor whiteColor];
        self.textView.attributedText = [[NSMutableAttributedString alloc] initWithString:@"这是文本" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Thonburi-Bold" size:30]}];////,NSShadowAttributeName:shadow
    }
    
    
    [self.view addSubview:self.textView];
}

- (void)doneback
{
    [self.textView sizeToFit];
    CGRect rect = self.textView.frame;
    rect.size.height += 1;
    self.textView.frame = rect;
    
    UIImage *image = [DBEditViewController captureView:self.textView];
    
    CGFloat width = self.view.bounds.size.width;
    if (self.textView.bounds.size.width < width - 30) {
        CGRect rect = self.textView.frame;
        rect.size.width = width - 30;
        self.textView.frame = rect;
    }
    
    
    if (image) {
        !self.doneBlock ? : self.doneBlock(image,self.textView);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text]) {
        
        [textView resignFirstResponder];
        [self doneback];
        return NO;
    }
    
    if (range.length == 0) {//增加
        if (textView.bounds.size.height >= 400) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.textView sizeToFit];
    CGFloat width = self.view.bounds.size.width;
    if (self.textView.bounds.size.width < width - 30) {
        CGRect rect = self.textView.frame;
        rect.size.width = width - 30;
        self.textView.frame = rect;
    }
    
    if (textView.bounds.size.height >= 400) {
        [textView resignFirstResponder];
    }
    
}

+ (UIImage *)captureView:(UIView *)view
{
    CGSize size = view.bounds.size;
    if ([view isKindOfClass:[UIScrollView class]]) {
        size = ((UIScrollView *)view).contentSize;
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

@end
