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

    init(saveLocationUseCase: SaveLocationUseCase = DefaultSaveLocationUseCase()) {
        self.saveLocationUseCase = saveLocationUseCase
    }

    func saveDrawing(_ drawing: Data) {
        guard let location = Location(locationType: .drawing, locationImage: drawing) else { return }
        saveLocationUseCase.save(location: location)
    }
}
