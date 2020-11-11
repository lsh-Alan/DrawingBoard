//
//  ViewController.m
//  Gesture
//
//  Created by Alan on 2020/11/10.
//

#import "ViewController.h"

#import "DrawingBoard.h"
#import "DBEditViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) DrawingBoard *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DrawingBoard *db = [[DrawingBoard alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    
    [self.view addSubview:db];
    self.db = db;
    
    [db setBackGroundImage:[UIImage imageNamed:@"background"]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 50, 50)];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    button1.backgroundColor = [UIColor grayColor];
    [button1 addTarget:self action:@selector(addText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 400, 50, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 450, 400, 400)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    
       NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
       for(NSInteger i = 0;i < familyNames.count;i++ ){
           NSLog(@"Family name: %@", familyNames[i]);
           NSArray  *fontNames =[[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:familyNames[i]]];
           
           for(NSInteger m = 0; m <fontNames.count; m++ ) {
               NSLog(@"Font name: %@",fontNames[m]);
           }
       }
}

- (void)addImage
{
    [self.db addNewSubView:[UIImage imageNamed:@"1"] TextView:nil];
}

- (void)addText
{
    DBEditViewController *editVC = [[DBEditViewController alloc] init];
    editVC.doneBlock = ^(UIImage * _Nonnull image, DrawingBoardTextView * _Nonnull textView) {
        [self.db addNewSubView:image TextView:textView];
        
    };
    self.definesPresentationContext = YES;
    editVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:editVC animated:YES completion:nil];
}

- (void)getImage
{
    UIImage *image = [self.db getImage];
    self.imageView.image = image;
}


@end
