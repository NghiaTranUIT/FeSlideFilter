//
//  FeViewController.m
//  FeSlideFilter
//
//  Created by Nghia Tran on 6/17/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import "FeViewController.h"
#import "FeSlideFilterView.h"

@interface FeViewController () <FeSlideFilterViewDataSource, FeSlideFilterViewDelegate>
@property (strong, nonatomic) FeSlideFilterView *slideFilterView;

///////////
-(void) initCommon;
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
-(void) initFeSlideFilterView
{
    _slideFilterView = [[FeSlideFilterView alloc] initWithFrame:CGRectMake(0, 0, 536, 320)];
    _slideFilterView.dataSource = self;
    _slideFilterView.delegate = self;
    
    [self.view addSubview:_slideFilterView];
}

#pragma mark - 
-(NSInteger) numberOfFilter
{
    return 5;
}
-(UIImage *) imageOriginal
{
    
}
-(NSString *) FeSlideFilterView:(FeSlideFilterView *)sender titleFilterAtIndex:(NSInteger)index
{
    
}
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *)sender imageAfterFilterAtIndex:(NSInteger)index
{
    
}
@end
