//
//  RCTBaiduMap.m
//  RCTBaiduMap
//
//  Created by lovebing on 4/17/2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#import "RCTBaiduMapView.h"
#import "RCTBaiduMapOverlay.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface RCTBaiduMapView ()<BMKLocationServiceDelegate>
@end

@implementation RCTBaiduMapView {
    // BMKMapView* _mapView;
    BMKPointAnnotation* _annotation;
    NSMutableArray* _annotations;

    CLLocationManager *_locationManager;
    BMKLocationService *_locationService;
}

/**
 * User location. 
 */ 
- (void)setShowsUserLocation:(BOOL)showsUserLocation
{    
    if (self.showsUserLocation != showsUserLocation) {
        if (showsUserLocation && !_locationService) {
            _locationService = [BMKLocationService new];
            _locationService.distanceFilter = 5;
            _locationService.delegate = self;
            [_locationService startUserLocationService];
            NSLog(@"[BaiduMapView setShowsUserLocation] init locationService");
        } else if (showsUserLocation) {
            NSLog(@"[BaiduMapView setShowsUserLocation] start location service");
            [_locationService startUserLocationService];
        }else if (!showsUserLocation && _locationService) {
            NSLog(@"[BaiduMapView setShowsUserLocation] stop location service");
            [_locationService stopUserLocationService];
        }
        super.showsUserLocation = showsUserLocation;
    }
}

//- (void)setFollowUserLocation:(BOOL)followUserLocation
//{
//    if (self.followUserLocation != followUserLocation) {
//        if (followUserLocation) {
//            self.userTrackingMode = BMKUserTrackingModeFollow;
//        } else {
//            self.userTrackingMode = BMKUserTrackingModeNone;
//        }
//        _followUserLocation = followUserLocation;
//    }
//}

//- (void)setUserLocationViewParams:(BMKLocationViewDisplayParam *)userLocationViewParams
//{
//    if (self.userLocationViewParams != userLocationViewParams) {
//        [self updateLocationViewWithParam:userLocationViewParams];
//        _userLocationViewParams = userLocationViewParams;
//    }
//}

/**
 * props
 */
-(void)setZoom:(float)zoom {
    self.zoomLevel = zoom;
}

-(void)setCenterLatLng:(NSDictionary *)LatLngObj {
    double lat = [RCTConvert double:LatLngObj[@"lat"]];
    double lng = [RCTConvert double:LatLngObj[@"lng"]];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat, lng);
    self.centerCoordinate = point;
}

/**
 * Markers
 */
-(void)setMarker:(NSDictionary *)option {
    NSLog(@"setMarker");
    if(option != nil) {
        if(_annotation == nil) {
            _annotation = [[BMKPointAnnotation alloc]init];
            [self addMarker:_annotation option:option];
        }
        else {
            [self updateMarker:_annotation option:option];
        }
    }
}

-(void)setMarkers:(NSArray *)markers {
    int markersCount = [markers count];
    if(_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
    }
    if(markers != nil) {
        for (int i = 0; i < markersCount; i++)  {
            NSDictionary *option = [markers objectAtIndex:i];
            
            BMKPointAnnotation *annotation = nil;
            if(i < [_annotations count]) {
                annotation = [_annotations objectAtIndex:i];
            }
            if(annotation == nil) {
                annotation = [[BMKPointAnnotation alloc]init];
                [self addMarker:annotation option:option];
                [_annotations addObject:annotation];
            }
            else {
                [self updateMarker:annotation option:option];
            }
        }
        
        int _annotationsCount = [_annotations count];
        
        NSString *smarkersCount = [NSString stringWithFormat:@"%d", markersCount];
        NSString *sannotationsCount = [NSString stringWithFormat:@"%d", _annotationsCount];
        NSLog(smarkersCount);
        NSLog(sannotationsCount);
        
        if(markersCount < _annotationsCount) {
            int start = _annotationsCount - 1;
            for(int i = start; i >= markersCount; i--) {
                BMKPointAnnotation *annotation = [_annotations objectAtIndex:i];
                [self removeAnnotation:annotation];
                [_annotations removeObject:annotation];
            }
        }
        
        
    }
}

-(CLLocationCoordinate2D)getCoorFromMarkerOption:(NSDictionary *)option {
    double lat = [RCTConvert double:option[@"latitude"]];
    double lng = [RCTConvert double:option[@"longitude"]];
    CLLocationCoordinate2D coor;
    coor.latitude = lat;
    coor.longitude = lng;
    return coor;
}

-(void)addMarker:(BMKPointAnnotation *)annotation option:(NSDictionary *)option {
    [self updateMarker:annotation option:option];
    [self addAnnotation:annotation];
}

-(void)updateMarker:(BMKPointAnnotation *)annotation option:(NSDictionary *)option {
    CLLocationCoordinate2D coor = [self getCoorFromMarkerOption:option];
    NSString *title = [RCTConvert NSString:option[@"title"]];
    if(title.length == 0) {
        title = nil;
    }
    annotation.coordinate = coor;
    annotation.title = title;
}

/**
 * Overlays / Polylines
 */

- (void)setOverlays:(NSArray *)overlays
{
    NSMutableArray<NSString *> *newOverlayIDs = [NSMutableArray new];
    NSMutableArray<RCTBaiduMapOverlay *> *overlaysToDelete = [NSMutableArray new];
    NSMutableArray<RCTBaiduMapOverlay *> *overlaysToAdd = [NSMutableArray new];
    
    for (RCTBaiduMapOverlay *overlay in overlays) {
        if (![overlay isKindOfClass:[RCTBaiduMapOverlay class]]) {
            continue;
        }
        
        [newOverlayIDs addObject:overlay.identifier];
        
        if (![_overlayIDs containsObject:overlay.identifier]) {
            [overlaysToAdd addObject:overlay];
        }
    }
    
    for (RCTBaiduMapOverlay *overlay in self.overlays) {
        if (![overlay isKindOfClass:[RCTBaiduMapOverlay class]]) {
            continue;
        }
        
        if (![newOverlayIDs containsObject:overlay.identifier]) {
            [overlaysToDelete addObject:overlay];
        }
    }
    
    if (overlaysToDelete.count > 0) {
        [self removeOverlays:(NSArray<id<BMKOverlay>> *)overlaysToDelete];
    }
    if (overlaysToAdd.count > 0) {
        [self addOverlays:(NSArray<id<BMKOverlay>> *)overlaysToAdd];
    }
    
    self.overlayIDs = newOverlayIDs;
    
    // if (self.autoZoomToSpan) {
    //     [self zoomToSpan];
    // }
}

// - (void)zoomToSpan:(NSArray<RCTBaiduMapAnnotation *> *)annotations andOverlays:(NSArray<RCTBaiduMapOverlay *> *)overlays
// {
//     CLLocationDegrees minLat = 0.0;
//     CLLocationDegrees maxLat = 0.0;
//     CLLocationDegrees minLon = 0.0;
//     CLLocationDegrees maxLon = 0.0;
//     BOOL hasInitialized = NO;
//     NSInteger index = 0;
//     if (annotations != nil) {
//         for (RCTBaiduMapAnnotation *annotation in annotations) {
//             if (index == 0 && hasInitialized == NO) {
//                 minLat = maxLat = annotation.coordinate.latitude;
//                 minLon = maxLon = annotation.coordinate.longitude;
//                 hasInitialized = YES;
//             } else {
//                 minLat = MIN(minLat, annotation.coordinate.latitude);
//                 minLon = MIN(minLon, annotation.coordinate.longitude);
//                 maxLat = MAX(maxLat, annotation.coordinate.latitude);
//                 maxLon = MAX(maxLon, annotation.coordinate.longitude);
//             }
//             index ++;
//         }
//     }
//     index = 0;
//     if (overlays != nil) {
//         for (RCTBaiduMapOverlay *overlay in overlays) {
//             for (NSInteger i = 0; i < overlay.pointCount; i++) {
//                 BMKMapPoint pt = overlay.points[i];
//                 CLLocationCoordinate2D coordinate = BMKCoordinateForMapPoint(pt);
//                 if (index == 0 && i == 0 && hasInitialized == NO) {
//                     minLat = maxLat = coordinate.latitude;
//                     minLon = maxLon = coordinate.longitude;
//                     hasInitialized = YES;
//                 } else {
//                     minLat = MIN(minLat, coordinate.latitude);
//                     minLon = MIN(minLon, coordinate.longitude);
//                     maxLat = MAX(maxLat, coordinate.latitude);
//                     maxLon = MAX(maxLon, coordinate.longitude);
//                 }
//             }
//             index ++;
//         }
//     }
    
//     if (hasInitialized) {
//         CLLocationCoordinate2D center;
//         center.latitude = (maxLat + minLat) * .5f;
//         center.longitude = (minLon + maxLon) * .5f;
//         BMKCoordinateSpan span = BMKCoordinateSpanMake(maxLat - minLat + 0.02, maxLon - minLon + 0.02);
        
//         BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
        
//         [self setRegion:region animated:YES];
//     }
// }

// - (void)zoomToSpan
// {
//     [self zoomToSpan:self.annotations andOverlays:self.overlays];
// }

// - (void)zoomToSpan:(NSArray<CLLocation *> *)locations
// {
//     if (locations == nil || locations.count == 0) {
//         [self zoomToSpan];
//     } else if (locations.count == 1) {
//         CLLocation *onlyLocation = locations.firstObject;
//         [self zoomToCenter:onlyLocation.coordinate];
//     } else {
//         CLLocationDegrees minLat = 0.0;
//         CLLocationDegrees maxLat = 0.0;
//         CLLocationDegrees minLon = 0.0;
//         CLLocationDegrees maxLon = 0.0;
//         NSInteger index = 0;
//         for (CLLocation *location in locations) {
//             if (index == 0) {
//                 minLat = maxLat = location.coordinate.latitude;
//                 minLon = maxLon = location.coordinate.longitude;
//             } else {
//                 minLat = MIN(minLat, location.coordinate.latitude);
//                 minLon = MIN(minLon, location.coordinate.longitude);
//                 maxLat = MAX(maxLat, location.coordinate.latitude);
//                 maxLon = MAX(maxLon, location.coordinate.longitude);
//             }
//             index ++;
//         }
        
//         CLLocationCoordinate2D center;
//         center.latitude = (maxLat + minLat) * .5f;
//         center.longitude = (minLon + maxLon) * .5f;
//         BMKCoordinateSpan span = BMKCoordinateSpanMake(maxLat - minLat + 0.02, maxLon - minLon + 0.02);
        
//         BMKCoordinateRegion region = BMKCoordinateRegionMake(center, span);
        
//         [self setRegion:region animated:YES];

//     }
// }

- (void)zoomToCenter:(CLLocationCoordinate2D)coordinate
{
    BMKMapStatus *newMapStatus = [BMKMapStatus new];
    newMapStatus.targetGeoPt = coordinate;
    newMapStatus.fLevel = 16;
    
    [self setMapStatus:newMapStatus withAnimation:YES];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (self.showsUserLocation) {
        [self updateLocationData:userLocation];
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    if (self.showsUserLocation) {
        // [self updateLocationData:userLocation];
        NSLog(@"heading is %@",userLocation.heading);
    }
}


@end
