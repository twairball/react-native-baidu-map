import {
  requireNativeComponent,
  View,
  NativeModules,
  Platform,
  DeviceEventEmitter,
  ColorPropType,  
} from 'react-native';

import React, {
  Component,
  PropTypes
} from 'react';

import MapTypes from './MapTypes';

export default class MapView extends Component {
  static propTypes = {
    ...View.propTypes,
    zoomControlsVisible: PropTypes.bool,
    trafficEnabled: PropTypes.bool,
    baiduHeatMapEnabled: PropTypes.bool,
    mapType: PropTypes.number,
    zoom: PropTypes.number,
    center: PropTypes.object,
    marker: PropTypes.object,
    markers: PropTypes.array,

    childrenPoints: PropTypes.array,
    onMapStatusChangeStart: PropTypes.func,
    onMapStatusChange: PropTypes.func,
    onMapStatusChangeFinish: PropTypes.func,
    onMapLoaded: PropTypes.func,
    onMapClick: PropTypes.func,
    onMapDoubleClick: PropTypes.func,
    onMarkerClick: PropTypes.func,
    onMapPoiClick: PropTypes.func,

    /**
     * User Location
     * @platform android
     */
    userLocation: PropTypes.shape({
      latitude: PropTypes.number.isRequired,
      longitude: PropTypes.number.isRequired,
    }),

    /**
     * User Location
     * @platform ios
     */
    showsUserLocation: PropTypes.bool, 

    /**
     * Map overlays
     */
    overlays: PropTypes.arrayOf(PropTypes.shape({
      /**
       * Polyline coordinates
       */
      coordinates: PropTypes.arrayOf(PropTypes.shape({
        latitude: PropTypes.number.isRequired,
        longitude: PropTypes.number.isRequired
      })),

      /**
       * Line attributes
       */
      lineWidth: PropTypes.number,
      strokeColor: ColorPropType,
      fillColor: ColorPropType,

      /**
       * Overlay id
       */
      id: PropTypes.string
    })),

  };

  static defaultProps = {
    zoomControlsVisible: true,
    trafficEnabled: false,
    baiduHeatMapEnabled: false,
    mapType: MapTypes.NORMAL,
    childrenPoints: [],
    marker: null,
    markers: [],
    center: null,
    zoom: 10,

    showsUserLocation: false,       
    userLocation: null, 

    overlays: [],
  };

  constructor() {
    super();
  }

  _onChange(event) {
    if (typeof this.props[event.nativeEvent.type] === 'function') {
      this.props[event.nativeEvent.type](event.nativeEvent.params);
    }
  }

  render() {
    return <BaiduMapView {...this.props} onChange={this._onChange.bind(this)}/>;
  }
}

const BaiduMapView = requireNativeComponent('RCTBaiduMapView', MapView, {
  nativeOnly: {onChange: true}
});
