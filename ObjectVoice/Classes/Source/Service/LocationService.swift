//
//  LocationService.swift
//  ObjectVoice
//
//  Created by James Tice on 8/26/18.
//  Copyright © 2018 ObjectVoice Inc. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationService   {
    
    
    public static let KEY_LAST_LAT = "ov_last_lat"
    public static let KEY_LAST_LON = "ov_last_lon"
    public static let KEY_LAST_ALTITUDE = "ov_last_altitude"
    public static let KEY_LAST_HORIZONTAL_ACCURACY = "ov_last_horizontal_accuracy"
    public static let KEY_LAST_VERTICAL_ACCURACY = "ov_last_vertical_accuracy"
    public static let KEY_LAST_TIMESTAMP = "ov_last_location_timestamp"

    var last_location: CLLocation?;
    
    public init()  {
        let defaults = UserDefaults.standard
        let lat = defaults.double(forKey: LocationService.KEY_LAST_LAT)
        let lon = defaults.double(forKey: LocationService.KEY_LAST_LON)
        let alt = defaults.double(forKey: LocationService.KEY_LAST_ALTITUDE)
        let horiz_accuracy = defaults.double(forKey: LocationService.KEY_LAST_HORIZONTAL_ACCURACY)
        let vert_accuracy = defaults.double(forKey: LocationService.KEY_LAST_VERTICAL_ACCURACY)
        let timestamp = defaults.object(forKey: LocationService.KEY_LAST_TIMESTAMP) as? Date ?? Date(timeIntervalSince1970: 0)
        let coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.last_location = CLLocation(coordinate: coords, altitude: alt, horizontalAccuracy: horiz_accuracy, verticalAccuracy: vert_accuracy, timestamp: timestamp)
        
    }
    
    public func getLastLocation() -> CLLocation?  {
        return last_location
    }
    
    public func storeLastLocation(location: CLLocation)    {
        let defaults = UserDefaults.standard
        defaults.set(location.coordinate.latitude, forKey: LocationService.KEY_LAST_LAT)
        defaults.set(location.coordinate.longitude, forKey: LocationService.KEY_LAST_LON)
        defaults.set(location.altitude, forKey: LocationService.KEY_LAST_ALTITUDE)
        defaults.set(location.horizontalAccuracy, forKey: LocationService.KEY_LAST_HORIZONTAL_ACCURACY)
        defaults.set(location.verticalAccuracy, forKey: LocationService.KEY_LAST_VERTICAL_ACCURACY)
        defaults.set(location.timestamp, forKey: LocationService.KEY_LAST_TIMESTAMP)
        self.last_location = location
    }
    
}
