//
//  MapSnapshotProvider.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/04/01.
//

import MapKit

protocol MapSnapshotProvider {

    func snapShotMap(latitude: Double,
                     longitude: Double,
                     delta span: Double,
                     imageSize: CGSize,
                     completion: @escaping (Result<Data, Error>) -> Void)
}

struct DefaultMapSnapshotProvider: MapSnapshotProvider {

    func snapShotMap(latitude: Double,
                     longitude: Double,
                     delta span: Double,
                     imageSize: CGSize,
                     completion: @escaping (Result<Data, Error>) -> Void) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let region = MKCoordinateRegion(center: location, span: spanValue)
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = imageSize

        let mapSnapshotter: MKMapSnapshotter = MKMapSnapshotter(options: options)
        mapSnapshotter.start { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let snapShotImage = snapshot?.image,
               let imageData = snapShotImage.pngData() {
                completion(.success(imageData))
            }
        }
    }
}
