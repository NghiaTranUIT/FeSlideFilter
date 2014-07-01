//
//  FeViewController.m
//  FeSlideFilter
//
//  Created by Nghia Tran on 6/17/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import "FeViewController.h"
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface FeViewController () <FeSlideFilterViewDataSource, FeSlideFilterViewDelegate>
@property (strong, nonatomic) FeSlideFilterView *slideFilterView;
@property (strong, nonatomic) NSMutableArray *arrPhoto;
@property (strong, nonatomic) NSArray *arrTittleFilter;

///////////
-(void) initCommon;
-(void) initPhotoFilter;
-(void) initTitle;
-(void) initFeSlideFilterView;
@end

@implementation FeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCommon];
    
    [self initPhotoFilter];
    
    [self initTitle];
    
    [self initFeSlideFilterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init
-(void) initCommon
{
    
}
-(void) initPhotoFilter
{
    _arrPhoto = [NSMutableArray arrayWithCapacity:5];
    
    for (NSInteger i = 0; i < 5; i++)
    {
        if (i == 4)
        {
            UIImage *image = [self imageDependOnDevice];
            [_arrPhoto addObject:image];
        }
        else
        {
            NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%d",i + 1];
            
            //////////
            // FIlter with LUT
            // Load photo
            UIImage *photo = [self imageDependOnDevice];
            
            // Create filter
            CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
            
            // Set parameter
            CIImage *ciImage = [[CIImage alloc] initWithImage:photo];
            [lutFilter setValue:ciImage forKey:@"inputImage"];
            CIImage *outputImage = [lutFilter outputImage];
            
            CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
            
            UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
            
            
            [_arrPhoto addObject:newImage];
        }
    }
}
-(void) initTitle
{
    _arrTittleFilter = @[@"Los Angeles",@"Paris",@"London",@"Rio",@"Original"];
}
-(void) initFeSlideFilterView
{
    CGRect frame;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (isiPhone5)
            frame = CGRectMake(0, 0, 568, 320);
        else
            frame = CGRectMake(0, 0, 480, 320);
    }
    else
    {
        frame = CGRectMake(0, 0, 1024, 768);
    }
    _slideFilterView = [[FeSlideFilterView alloc] initWithFrame:frame];
    _slideFilterView.dataSource = self;
    _slideFilterView.delegate = self;
    
    [self.view addSubview:_slideFilterView];
    
    // Btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    
    _slideFilterView.doneBtn = btn;
}

#pragma mark - Delegate / Data Source
-(NSInteger) numberOfFilter
{
    return 5;
}
-(NSString *) FeSlideFilterView:(FeSlideFilterView *)sender titleFilterAtIndex:(NSInteger)index
{
    return _arrTittleFilter[index];
}
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *)sender imageFilterAtIndex:(NSInteger)index
{
    return _arrPhoto[index];
}
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didTapDoneButtonAtIndex:(NSInteger)index
{
    NSLog(@"did tap at index = %ld",(long)index);
}
-(NSString *) kCAContentGravityForLayer
{
    return kCAGravityResizeAspectFill;
}
#pragma mark - Private
-(UIImage *) imageDependOnDevice
{
    UIImage *imageOriginal;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        imageOriginal = [UIImage imageNamed:@"sample.jpg"];
    }
    else
    {
        imageOriginal = [UIImage imageNamed:@"sample_iPad.jpg"];
    }
    return imageOriginal;
}
@end
