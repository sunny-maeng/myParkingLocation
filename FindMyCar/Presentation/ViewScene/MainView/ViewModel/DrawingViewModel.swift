//
//  DrawingViewModel.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/30.
//

import Foundation

final class DrawingViewModel {

    let defaultImage: String = "hand.draw"

    private let saveLocationUseCase: SaveLocationUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase

    init(saveLocationUseCase: SaveLocationUseCase = DefaultSaveLocationUseCase(),
         deleteLocationUseCase: DeleteLocationUseCase = DefaultDeleteLocationUseCase()) {
        self.saveLocationUseCase = saveLocationUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
    }

    func saveDrawing(_ drawing: Data) {
        guard let location = Location(locationType: .drawing, locationImage: drawing) else { return }
        saveLocationUseCase.save(location: location)
    }

    func deleteDrawing() {
        deleteLocationUseCase.deleteLocation()
    }
}
