//
//  WavyView.m
//
//  Created by Will Russell on 25/11/12.
//

#import "WavyView.h"

@implementation WavyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 100, 100);
    CGContextAddCurveToPoint(context,125,150,175,150,200,100);
    CGContextAddCurveToPoint(context,225,50,275,75,300,200);
    CGContextStrokePath(context);
}

@end
