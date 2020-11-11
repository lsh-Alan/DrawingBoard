//
//  DBEditViewController.m
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import "DBEditViewController.h"

@interface DBEditViewController ()<UITextViewDelegate>

@property(nonatomic, assign) CGFloat maxHeight;

@end

@implementation DBEditViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.layer.cornerRadius = 10;
    blurView.layer.masksToBounds = YES;
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];

    self.maxHeight = self.view.bounds.size.height;
    
    if (!self.textView) {
        CGFloat width = self.view.bounds.size.width;
        self.textView = [[DrawingBoardTextView alloc] initWithFrame:CGRectMake(15, 200, width - 30, 40)];
        self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.tintColor = [UIColor whiteColor];
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.delegate = self;
        
        
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
        shadow.shadowColor = [UIColor whiteColor];//PingFang sc  Regular常规   Medium中等。  Bold加粗   Heavy 特粗   //Thonburi-Bold  //HuaWenSongTi-1
        self.textView.attributedText = [[NSMutableAttributedString alloc] initWithString:@"这是文本" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STSong" size:30],NSForegroundColorAttributeName:[UIColor whiteColor]}];////,NSShadowAttributeName:shadow //NSBackgroundColorAttributeName字体背景
    }
    
    self.textView.delegate = self;
    [self.view addSubview:self.textView];

    //检测键盘高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardAction:(NSNotification *)notif
{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [notif userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    self.maxHeight = self.view.bounds.size.height -[value CGRectValue].size.height;
    
    //留部分头部空间
    self.maxHeight -= 44;
    
    self.textView.center = CGPointMake(self.view.bounds.size.width/2.0, self.maxHeight/2.0) ;
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
        if (textView.bounds.size.height >= self.maxHeight) {
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
    
    textView.center = CGPointMake(self.view.bounds.size.width/2.0, self.maxHeight/2.0) ;
    
//    if (textView.bounds.size.height >= self.maxHeight) {
//        //[textView resignFirstResponder];
//    }
}

+ (UIImage *)captureView:(UIView *)view
{
    CGSize size = view.bounds.size;
    if ([view isKindOfClass:[UIScrollView class]]) {
        size = ((UIScrollView *)view).contentSize;
    }
    view.layer.backgroundColor = [UIColor clearColor].CGColor;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    
    
    [self.textView sizeToFit];
    CGFloat width = self.view.bounds.size.width;
    if (self.textView.bounds.size.width < width - 30) {
        CGRect rect = self.textView.frame;
        rect.size.width = width - 30;
        self.textView.frame = rect;
    }
    
    self.textView.center = CGPointMake(self.view.bounds.size.width/2.0, self.maxHeight/2.0) ;
    
    
}



@end
