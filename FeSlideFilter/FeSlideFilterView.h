//
//  FeSlideFilterView.h
//  FeSlideFilter
//
//  Created by Nghia Tran on 6/11/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol
@protocol FeSlideFilterViewDataSource;
@protocol FeSlideFilterViewDelegate;

@interface FeSlideFilterView : UIView
// Delegate
@property (weak, nonatomic) id<FeSlideFilterViewDelegate> delegate;

// Data Source
@property (weak, nonatomic) id<FeSlideFilterViewDataSource> dataSource;

// Number of filter
@property (assign, readonly, nonatomic) NSInteger numberOfFilter;

// Current index
@property (assign,readonly, nonatomic) NSInteger currentIndex;

//Done Btn
@property (strong, nonatomic) UIButton *doneBtn;

// Reload
-(void) reloadFilter;
@end

////////////////
// Protocol - Data source
@protocol FeSlideFilterViewDataSource <NSObject>

@required
-(NSInteger) numberOfFilter;
-(NSString *) FeSlideFilterView:(FeSlideFilterView *) sender titleFilterAtIndex:(NSInteger) index;
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *) sender imageFilterAtIndex:(NSInteger) index;

@optional
-(UIFont *) FeSlideFilterView:(FeSlideFilterView *) sender fontForTitleAtIndex:(NSInteger) index;
-(NSString *) kCAContentGravityForLayer;
@end

//////////////
// Protocol - Delegate
@protocol FeSlideFilterViewDelegate <NSObject>
@optional
-(void) FeSlideFilterView:(FeSlideFilterView *) sender didTapDoneButtonAtIndex:(NSInteger) index;
-(BOOL) FeSlideFilterView:(FeSlideFilterView *)sender shouldSlideFilterAtIndex:(NSInteger) index;
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didBeginSlideFilterAtIndex:(NSInteger) index;
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didEndSlideFilterAtIndex:(NSInteger) index;
@end

