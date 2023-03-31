//
//  MainViewModel.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/22.
//

import Foundation

final class MainViewModel {

    let savedLocation: Observable<Location?> = Observable(nil)
    let error: Observable<String?> = Observable(nil)
    let positioningButtonImage: String = "flag"
    let cameraButtonImage: String = "camera"
    let pencilButtonImage: String = "pencil"
    let refreshButtonImage: String = "arrow.clockwise"
    let errorTitle: String = "Error"

    private let fetchLocationUseCase: FetchLocationUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase


    init(fetchLocationUseCase: FetchLocationUseCase = DefaultFetchLocationUseCase(),
         deleteLocationUseCase: DeleteLocationUseCase = DefaultDeleteLocationUseCase()) {
        self.fetchLocationUseCase = fetchLocationUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
    }

    // MARK: - GenerateView
    func generateDefaultView() -> DefaultView {
        return DefaultView()
    }

    func generateMapView(location: Location) -> MapView {
        return MapView(viewModel: MapViewModel(location: location))
    }

    func generatePhotoView(data: Data? = nil) -> PhotoView {
        return PhotoView(photoData: data)
    }

    func generateDrawingView(data: Data? = nil) -> DrawingView {
        return DrawingView(drawingData: data)
    }
}

// MARK: - Handle Location Data
extension MainViewModel {

    func fetchLocation() {
        fetchLocationUseCase.fetchLocation { result in
            switch result {
            case .success(let location):
                self.savedLocation.value = location
            case .failure:
                self.error.value = "저장된 데이터를 가져오는 데 실패했습니다"
            }
        }
    }

    func deleteLocation() {
        deleteLocationUseCase.deleteLocation()
    }
}
