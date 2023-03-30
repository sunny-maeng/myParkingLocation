//
//  PhotoViewModel.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/30.
//

import Foundation

final class PhotoViewModel {

    let defaultImage: String = "camera.viewfinder"

    private let saveLocationUseCase: SaveLocationUseCase

    init(saveLocationUseCase: SaveLocationUseCase = DefaultSaveLocationUseCase()) {
        self.saveLocationUseCase = saveLocationUseCase
    }

    func savePhoto(_ photo: Data) {
        guard let location = Location(locationType: .photo, locationImage: photo) else { return }
        saveLocationUseCase.save(location: location)
    }
}
