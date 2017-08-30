//
//  RCTBaiduMap.m
//  RCTBaiduMap
//
//  Created by lovebing on 4/17/2016.
//  Copyright © 2016 lovebing.org. All rights reserved.
//

#import "RCTBaiduMapView.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@interface RCTBaiduMapView ()<BMKLocationServiceDelegate>
@end

@implementation RCTBaiduMapView {
    BMKMapView* _mapView;
    BMKPointAnnotation* _annotation;
    NSMutableArray* _annotations;

    CLLocationManager *_locationManager;
    BMKLocationService *_locationService;
}

- (void)setShowsUserLocation:(BOOL)showsUserLocation
{    
    if (self.showsUserLocation != showsUserLocation) {
        if (showsUserLocation && !_locationService) {
            _locationService = [BMKLocationService new];
            _locationService.distanceFilter = 5;
            _locationService.delegate = self;
            [_locationService startUserLocationService];
        } else if (showsUserLocation) {
            [_locationService startUserLocationService];
        }else if (!showsUserLocation && _locationService) {
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

-(void)setZoom:(float)zoom {
    self.zoomLevel = zoom;
}

-(void)setCenterLatLng:(NSDictionary *)LatLngObj {
    double lat = [RCTConvert double:LatLngObj[@"lat"]];
    double lng = [RCTConvert double:LatLngObj[@"lng"]];
    CLLocationCoordinate2D point = CLLocationCoordinate2DMake(lat, lng);
    self.centerCoordinate = point;
}

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
        [self updateLocationData:userLocation];
    }
}


@end
