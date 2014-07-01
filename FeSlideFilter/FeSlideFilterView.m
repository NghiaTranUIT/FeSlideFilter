//
//  FeSlideFilterView.m
//  FeSlideFilter
//
//  Created by Nghia Tran on 6/11/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import "FeSlideFilterView.h"
typedef NS_ENUM(NSInteger, FeSlideFilterViewPosition) {
    FeSlideFilterViewPositionStart,
    FeSlideFilterViewPositionEnd,
    FeSlideFilterViewPositionMid
};
typedef NS_ENUM(NSInteger, FeSlideFilterViewState) {
    FeSlideFilterViewStateScrollingToLeft,
    FeSlideFilterViewStateScrollingToRight,
    FeSlideFilterViewStateNone
};

@interface FeSlideFilterView () <UIScrollViewDelegate>
// Front Layer
@property (strong, nonatomic) CALayer *frontLayer;

// Back Layer
@property (strong, nonatomic) CALayer *backLayer;

// Mask Layer
@property (strong, nonatomic) CALayer *maskLayer;

// Scroll View
@property (strong, nonatomic) UIScrollView *scrollView;

// Position
@property (assign, nonatomic) FeSlideFilterViewPosition currentPosition;

// State
@property (assign, nonatomic) FeSlideFilterViewState currentState;

-(NSString *) getAndVerityKCAContentGravityFromDataSource;

/////////////////////
// Init
-(void) initCommon;
-(void) initFrontLayer;
-(void) initBackLayer;
-(void) initMaskLayer;
-(void) initScrollView;
-(void) initDoneButton;

-(void) configureSlideFilterView;
-(void) configureScrollView;
-(void) configureLayer;

//////////////
// Verify
-(void) verify;

//////////////
// Handle
-(void) prepareSlideFilterWithScrollView:(UIScrollView *) scrollView;
-(void) handleSlideFilterWithScroll:(UIScrollView *) scrollView;
-(void) finishSlideFilterWithScrollView:(UIScrollView *) scrollView;

// Dont Btn
-(void) doneBtnTapped:(UIButton *) sender;

@end

@implementation FeSlideFilterView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCommon];
        
        [self initFrontLayer];
        
        [self initBackLayer];
        
        [self initMaskLayer];
        
        [self initScrollView];
    }
    return self;
}
-(void) initCommon
{
    _currentIndex = 0;
    _currentPosition = FeSlideFilterViewPositionStart;
    _currentState = FeSlideFilterViewStateNone;
    
}
-(void) initFrontLayer
{
    // Front
    _frontLayer = [CALayer layer];
    _frontLayer.frame = self.bounds;
    _frontLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    // Add sublayer
    [self.layer addSublayer:_frontLayer];
}
-(void) initBackLayer
{
    // Back
    _backLayer = [CALayer layer];
    _backLayer.frame = self.bounds;
    _backLayer.contentsGravity = kCAGravityResizeAspectFill;
    
    // Add sublayer
    [self.layer insertSublayer:_backLayer below:_frontLayer];
}
-(void) initMaskLayer
{
    _maskLayer = [CALayer layer];
    _maskLayer.frame = self.bounds;
    _maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _maskLayer.anchorPoint = CGPointMake(0, 0);
    _maskLayer.position = CGPointMake(0, 0);
    
    _frontLayer.mask = _maskLayer;
}
-(void) initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
}
-(void) initDoneButton
{
    // Add subView
    if (!_doneBtn.superview)
    {
        [self addSubview:_doneBtn];
    }
    
    // Add target
    [_doneBtn addTarget:self action:@selector(doneBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) configureSlideFilterView
{
    // Verify
    [self verify];
    
    // Number of filter
    _numberOfFilter = [_dataSource numberOfFilter];
    
    // ScrollView
    [self configureScrollView];
    
    // Layer and mask
    [self configureLayer];
    
    // Set content gravity
    if ([_dataSource respondsToSelector:@selector(kCAContentGravityForLayer)])
    {
        NSString *strContentFravity = [self getAndVerityKCAContentGravityFromDataSource];
        _frontLayer.contentsGravity = strContentFravity;
        _backLayer.contentsGravity = strContentFravity;
    }
    
}
-(void) configureScrollView
{
    CGRect frame = self.bounds;
    
    // Content size
    _scrollView.contentSize = CGSizeMake(frame.size.width * _numberOfFilter, frame.size.height);
    
    // Create title lable
    for (NSInteger i = 0 ; i < _numberOfFilter; i++)
    {
        CGRect frameLabel = CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height);
        UILabel *titleFilter = [[UILabel alloc] initWithFrame:frameLabel];
        titleFilter.backgroundColor = [UIColor clearColor];
        titleFilter.textAlignment = NSTextAlignmentCenter;
        titleFilter.textColor = [UIColor whiteColor];
        
        // Font
        if ([_dataSource respondsToSelector:@selector(FeSlideFilterView:fontForTitleAtIndex:)])
        {
            titleFilter.font = [_dataSource FeSlideFilterView:self fontForTitleAtIndex:i];
        }
        else
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                titleFilter.font = [UIFont fontWithName:@"Avenir" size:60];
            }
            else
            {
                titleFilter.font = [UIFont fontWithName:@"Avenir" size:140];
            }
        }
        
        // Title
        titleFilter.text = [_dataSource FeSlideFilterView:self titleFilterAtIndex:i];
        
        // Subview
        [_scrollView addSubview:titleFilter];
    }
    
    //Paging
    _scrollView.pagingEnabled = YES;
    
    [self addSubview:_scrollView];
}
-(void) configureLayer
{
    if (_currentIndex == 0 && _currentPosition == FeSlideFilterViewPositionStart)
    {
        // Front
        UIImage *originalImage = [_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex];
        _frontLayer.contents = (id)originalImage.CGImage;
        
        // Back
        UIImage *nextImage = [_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex + 1];
        _backLayer.contents = (id) nextImage.CGImage;
        
        // mask
        _maskLayer.position = CGPointMake(0, 0);
    }
}
-(void) verify
{
    NSAssert(_dataSource, @"Data source is nil");
    NSAssert([_dataSource conformsToProtocol:@protocol(FeSlideFilterViewDataSource)], @"You must comform Data Source");
    NSAssert([_dataSource respondsToSelector:@selector(numberOfFilter)], @"You must implement NumberOfFilter method");
    NSAssert([_dataSource respondsToSelector:@selector(FeSlideFilterView:imageFilterAtIndex:)], @"You must implement FeSlideFilterView:imageAfterFilterAtIndex: method");
    NSAssert([_dataSource respondsToSelector:@selector(FeSlideFilterView:titleFilterAtIndex:)], @"You must implement FeSlideFilterView:titleFilterAtIndex: method");
}
-(NSString *) getAndVerityKCAContentGravityFromDataSource
{
    NSString *string = [_dataSource kCAContentGravityForLayer];
    if (string == nil || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        NSLog(@"ERROR : kCAContentGravity property should NOT be nil or empty");
        NSAssert(NO, @"kCAContentGravity property should NOT be nil or empty");
        return @"";
    }
    else
    {
        return string;
    }

}
#pragma mark - Getter / setter
-(void) setDataSource:(id<FeSlideFilterViewDataSource>)dataSource
{
    if (_dataSource == dataSource)
        return;
    _dataSource = dataSource;
    
    [self reloadFilter];
}
-(void) setDoneBtn:(UIButton *)doneBtn
{
    if (_doneBtn == doneBtn)
        return;
    
    _doneBtn = doneBtn;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _doneBtn.center = CGPointMake(self.bounds.size.width - 30,self.bounds.size.height - 30);
    }
    else
    {
        _doneBtn.center = CGPointMake(self.bounds.size.width - 50,self.bounds.size.height - 50);
    }
    
    
    [self initDoneButton];
}
-(void) reloadFilter
{
    [self configureSlideFilterView];
}
#pragma mark - ScrollView Delegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self prepareSlideFilterWithScrollView:scrollView];
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self handleSlideFilterWithScroll:scrollView];
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self finishSlideFilterWithScrollView:scrollView];
}
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate)
    {
        _scrollView.scrollEnabled = NO;
    }
}

#pragma mark - Handler
-(void) prepareSlideFilterWithScrollView:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(FeSlideFilterView:shouldSlideFilterAtIndex:)])
    {
        BOOL isShouldSlide = [_delegate FeSlideFilterView:self shouldSlideFilterAtIndex:_currentIndex];
        
        if (isShouldSlide == NO)
            return;
    }
    
    CGPoint velocity = [_scrollView.panGestureRecognizer velocityInView:self];
    
    if (_currentIndex == 0 && _currentPosition == FeSlideFilterViewPositionStart && _currentState == FeSlideFilterViewStateNone)
    {
        if (velocity.x < 0)
        {
            // Default
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _maskLayer.position = CGPointZero;
            
            // Next
            _frontLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:0] CGImage];
            _backLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:1] CGImage];
            
            [CATransaction commit];
            
            // Position
            // State
            _currentState = FeSlideFilterViewStateScrollingToLeft;
            
        }
    }
    else if ((_currentIndex > 0 && _currentIndex < _numberOfFilter - 1) && _currentPosition == FeSlideFilterViewPositionMid && _currentState == FeSlideFilterViewStateNone)
    {
        if (velocity.x < 0)
        {
            // Default
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            _maskLayer.position = CGPointZero;
            
            // Next
            _frontLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex] CGImage];
            _backLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex + 1] CGImage];
            
            [CATransaction commit];
            
            // Position
            // State
            _currentState = FeSlideFilterViewStateScrollingToLeft;
        }
        else
        {
            // Default
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            // Default position
            _maskLayer.position = CGPointZero;
            
            // Next
            _frontLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex] CGImage];
            _backLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex - 1] CGImage];
            
            [CATransaction commit];
            
            // Position
            // State
            _currentState = FeSlideFilterViewStateScrollingToRight;
            
        }
    }
    else if (_currentIndex == (_numberOfFilter - 1) && _currentPosition == FeSlideFilterViewPositionEnd && _currentState == FeSlideFilterViewStateNone)
    {
        if (velocity.x > 0)
        {
            // Default
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            // Default position
            _maskLayer.position = CGPointZero;
            
            // Next
            _frontLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex] CGImage];
            _backLayer.contents = (id)[[_dataSource FeSlideFilterView:self imageFilterAtIndex:_currentIndex - 1] CGImage];
            
            [CATransaction commit];
            
            // Position
            // State
            _currentState = FeSlideFilterViewStateScrollingToRight;

        }
    }
    
    // Delegate
    if ([_delegate respondsToSelector:@selector(FeSlideFilterView:didBeginSlideFilterAtIndex:)])
    {
        [_delegate FeSlideFilterView:self didBeginSlideFilterAtIndex:_currentIndex];
    }
    
}
-(void) handleSlideFilterWithScroll:(UIScrollView *)scrollView
{
    if (_currentState == FeSlideFilterViewStateScrollingToLeft)
    {
        CGFloat denta =  scrollView.contentOffset.x - self.bounds.size.width * _currentIndex;
        CGFloat percent = denta / self.bounds.size.width;
        
        // Adjust mask's frame
        if (percent >= 0 && percent <= 1)
        {
            // Disable implicit animation
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            _maskLayer.frame = CGRectMake(0 - percent * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
            
            [CATransaction commit];
        }
    }
    if (_currentState == FeSlideFilterViewStateScrollingToRight)
    {
        CGFloat denta =  self.bounds.size.width * _currentIndex - scrollView.contentOffset.x;
        CGFloat percent = denta / self.bounds.size.width;
        
        // Adjust mask's frame
        if (percent >= 0 && percent <= 1)
        {
            // Disable implicit animation
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            
            _maskLayer.frame = CGRectMake( percent * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
            
            [CATransaction commit];
        }
    }
}
-(void) finishSlideFilterWithScrollView:(UIScrollView *)scrollView
{
    _scrollView.scrollEnabled = YES;
    
    // Change state
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _currentIndex = page;
    
    if (_currentIndex == 0)
    {
        _currentPosition = FeSlideFilterViewPositionStart;
        _currentState = FeSlideFilterViewStateNone;
    }
    else if (_currentIndex == _numberOfFilter - 1)
    {
        _currentPosition = FeSlideFilterViewPositionEnd;
        _currentState = FeSlideFilterViewStateNone;
    }
    else
    {
        _currentPosition = FeSlideFilterViewPositionMid;
        _currentState = FeSlideFilterViewStateNone;
    }
    
    // Delegate
    if ([_delegate respondsToSelector:@selector(FeSlideFilterView:didEndSlideFilterAtIndex:)])
    {
        [_delegate FeSlideFilterView:self didEndSlideFilterAtIndex:_currentIndex];
    }
}

#pragma mark - Done Btn
-(void) doneBtnTapped:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(FeSlideFilterView:didTapDoneButtonAtIndex:)])
    {
        [_delegate FeSlideFilterView:self didTapDoneButtonAtIndex:_currentIndex];
    }
}
@end
