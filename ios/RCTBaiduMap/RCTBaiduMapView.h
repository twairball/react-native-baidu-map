//
//  RCTBaiduMap.h
//  RCTBaiduMap
//
//  Created by lovebing on 4/17/2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#ifndef RCTBaiduMapView_h
#define RCTBaiduMapView_h


#import <React/RCTViewManager.h>
#import <React/RCTConvert+CoreLocation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <UIKit/UIKit.h>

#import "RCTBaiduMapOverlay.h"

@interface RCTBaiduMapView : BMKMapView <BMKMapViewDelegate>

@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) NSArray<NSString *> *overlayIDs;
@property (nonatomic, assign) BOOL autoZoomToSpan;

-(void)setZoom:(float)zoom;
-(void)setCenterLatLng:(NSDictionary *)LatLngObj;
-(void)setMarker:(NSDictionary *)Options;
-(void)setMarkers:(NSArray *)markers;
-(void)setShowsUserLocation:(BOOL)showsUserLocation;

- (void)setOverlays:(NSArray *)overlays;

// - (void)zoomToSpan;
// - (void)zoomToSpan:(NSArray<RCTBaiduMapAnnotation *> *)annotations andOverlays:(NSArray<RCTBaiduMapOverlay *> *)overlays;
// - (void)zoomToSpan:(NSArray<CLLocation *> *)locations;
@end

#endif
