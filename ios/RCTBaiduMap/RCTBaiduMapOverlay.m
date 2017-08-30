//
//  RCTAMapOverlay.m
//  RCTAMap
//
//  Created by yiyang on 16/2/29.
//  Copyright © 2016年 creditease. All rights reserved.
//

#import "RCTBaiduMapOverlay.h"

@implementation RCTBaiduMapOverlay

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count
{
    RCTBaiduMapOverlay * overlay = [[RCTBaiduMapOverlay alloc] init];
    [overlay setPolylineWithCoordinates:coordinates count:count];
    return overlay;
}

@end
