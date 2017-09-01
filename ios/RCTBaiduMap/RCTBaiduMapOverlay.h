//
//  RCTAMapOverlay.h
//  RCTAMap
//
//  Created by yiyang on 16/2/29.
//  Copyright © 2016年 creditease. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RCTBaiduMapOverlay : BMKPolyline<BMKAnnotation>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) UIColor *fillColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) BOOL lineDash;

+ (instancetype)polylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count;

@end
