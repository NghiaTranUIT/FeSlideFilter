FeSlideFilter
=============

Filter with own way !

Review Youtube : https://www.youtube.com/watch?v=KUN6bs9pl74&feature=youtu.be

## In Brief
FeSlideFilterView is subclass UIView. Bring new way to display your photo.

You can slide between filter by your touch. Gain more User Exp than nomal way.

## Requirement
FeSpringFlowLayout use UIKit Dynamics to implement.

So You must ensure your project has iOS version more than iOS 7.0.

And compatible with ARC or non-ARC.

## Sample code

In Sample code, I user LUT technique to apply filter to photo.

More info, visist my blog : http://nghiatran.me/index.php/filter-me-color-lookup-table-part-2/

If you wanna use LUT, please sure you added Core Image and OpenGL ES framwork to your project.

## How to use
FeSlideFilter use Data Source / Delgate pattern like UITableView.

Just provide filtered UIImage

and Title for each Filter.

Ex :
```objc
// Number of filter
-(NSInteger) numberOfFilter
{
    return 5;
}

// Title for filter at index
-(NSString *) FeSlideFilterView:(FeSlideFilterView *)sender titleFilterAtIndex:(NSInteger)index
{
    return _arrTittleFilter[index];
}

// Filtered UIImage at index
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *)sender imageFilterAtIndex:(NSInteger)index
{
    return _arrPhoto[index];
}

```

If you want to customize by yourself. Just assign your button with _doneBtn property.

```objc
// Btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    
    _slideFilterView.doneBtn = btn;
    
```

======================
## Data Source - Delegate
You can change behavior by changing 3 properties when init

Data Source :
```objc
@required
// Number of filter
-(NSInteger) numberOfFilter;

// Title filter at index
-(NSString *) FeSlideFilterView:(FeSlideFilterView *) sender titleFilterAtIndex:(NSInteger) index;

// Image at index
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *) sender imageFilterAtIndex:(NSInteger) index;

@optional
// Font at index
-(UIFont *) FeSlideFilterView:(FeSlideFilterView *) sender fontForTitleAtIndex:(NSInteger) index;
```

Delegate :
```objc 
// Call when user tapped Btn
-(void) FeSlideFilterView:(FeSlideFilterView *) sender didTapDoneButtonAtIndex:(NSInteger) index;

// Determine when user can slide
-(BOOL) FeSlideFilterView:(FeSlideFilterView *)sender shouldSlideFilterAtIndex:(NSInteger) index;

// Call when user have just slided
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didBeginSlideFilterAtIndex:(NSInteger) index;

// Call when user end Slide
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didEndSlideFilterAtIndex:(NSInteger) index;
```

## MIT License
Copyright (c) 2014 Nghia Tran

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Release notes
Version 1.0

Initial release
