//
//  SimpleProfileMap.swift
//  first-mac-app
//
//  Created by mostafa on 27.09.26.
//

import SwiftUI
import MapKit


struct SimpleProfileMap: View {
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )

        var body: some View {
           /* Map(coordinateRegion: $region, interactionModes: .all)
                .frame(width: 300, height: 200)
                .cornerRadius(8)
            */
            NativeMapView(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
                .frame(height: 200)
                .cornerRadius(8)
        }
}

// Simple helper model for the map pin
struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct NativeMapView: NSViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.appearance = NSAppearance(named: .aqua)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }

    func updateNSView(_ nsView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        nsView.setRegion(region, animated: false)
        
        // Clear old annotations and drop a pin
        nsView.removeAnnotations(nsView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        nsView.addAnnotation(pin)
    }
}





struct SafeMapView: NSViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeNSView(context: Context) -> MKMapView {
        // 1. Initialize map view
        let mapView = MKMapView(frame: .zero)
        
        // 2. CRITICAL FOR MACOS: Force layer backing so it doesn't render black
        mapView.wantsLayer = true
        
        // 3. Configure standard map features
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }

    func updateNSView(_ nsView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        nsView.setRegion(region, animated: false)
        
        nsView.removeAnnotations(nsView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        nsView.addAnnotation(pin)
    }
}
