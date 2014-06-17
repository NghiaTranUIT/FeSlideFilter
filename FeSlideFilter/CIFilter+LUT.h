//
//  CIFilter+LUT.h
//  FilterMe-PartTwo
//
//  Created by Nghia Tran on 6/17/14.
//  Copyright (c) 2014 Fe. All rights reserved.
//

#import <CoreImage/CoreImage.h>
@class CIFilter;

@interface CIFilter (LUT)
+(CIFilter *) filterWithLUT:(NSString *) name dimension:(NSInteger) n;
@end
