package org.lovebing.reactnative.baidumap;

import android.util.Log;
import android.widget.Button;

import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.InfoWindow;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.facebook.react.bridge.ReadableMap;

import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationData;

/**
 * Created by lovebing on Sept 28, 2016.
 */
public class MarkerUtil {

    public static void updateMaker(Marker maker, ReadableMap option) {
        LatLng position = getLatLngFromOption(option);
        maker.setPosition(position);
        maker.setTitle(option.getString("title"));
    }

    public static Marker addMarker(MapView mapView, ReadableMap option) {
        BitmapDescriptor bitmap = BitmapDescriptorFactory.fromResource(R.mipmap.icon_gcoding);
        LatLng position = getLatLngFromOption(option);
        OverlayOptions overlayOptions = new MarkerOptions()
                .icon(bitmap)
                .position(position)
                .title(option.getString("title"));

        Marker marker = (Marker)mapView.getMap().addOverlay(overlayOptions);
        return marker;
    }


    private static LatLng getLatLngFromOption(ReadableMap option) {
        double latitude = option.getDouble("latitude");
        double longitude = option.getDouble("longitude");
        return new LatLng(latitude, longitude);

    }

    public static MyLocationConfiguration getLocationConfig(MapView mapView) {
        BitmapDescriptor icon = BitmapDescriptorFactory.fromResource(R.mipmap.icon_geo); 
        MyLocationConfiguration config = new MyLocationConfiguration(
            MyLocationConfiguration.LocationMode.NORMAL, 
            true, 
            icon);
        
        return config;
    }

    public static MyLocationData getLocDataFromOption(ReadableMap option) {
        if (option == null) { return null; }

        double latitude = option.getDouble("latitude");
        double longitude = option.getDouble("longitude");
        // double direction = option.getDouble("direction");
        // double radius = option.getDouble("radius");

        MyLocationData locData = new MyLocationData.Builder()
            .longitude(longitude)
            .latitude(latitude)
            .build();
        return locData;
    }
}
