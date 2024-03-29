//
//  PhotoView.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/26.
//

import UIKit
import Photos

protocol PhotoViewDelegate: AnyObject {

    func requestCameraAuthorization()
    func openCamera(_ camera: UIImagePickerController)
    func makeButtonInactive()
}

final class PhotoView: UIView {

    weak var delegate: PhotoViewDelegate?

    private let viewModel: PhotoViewModel

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self

        return imagePickerController
    }()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constant.cornerRadius
        imageView.layer.borderWidth = Constant.borderWidth
        imageView.layer.borderColor = UIColor.mainBlue.cgColor
        imageView.clipsToBounds = true

        return imageView
    }()

    init(viewModel: PhotoViewModel = PhotoViewModel(), photoData: Data? = nil) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupView()

        if let photoData = photoData {
            setupPhoto(photoData)
        } else {
            setupDefaultImage(imageName: viewModel.defaultImage)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func openCamera() {
        guard checkCameraAuthorization() else { return }
        delegate?.openCamera(self.imagePickerController)
    }

    private func checkCameraAuthorization() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        var isCameraAuthorized: Bool = false

        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
                DispatchQueue.main.async {
                    if !isAuthorized {
                        self?.delegate?.requestCameraAuthorization()
                    } else {
                        guard let imagePickerController = self?.imagePickerController else { return }
                        self?.delegate?.openCamera(imagePickerController)
                    }
                }
            }
        case .restricted, .denied:
            self.delegate?.requestCameraAuthorization()
            isCameraAuthorized = false
        default:
            isCameraAuthorized = true
        }

        return isCameraAuthorized
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImageView.image = image
            self.photoImageView.contentMode = .scaleAspectFill
            self.save(photo: image)
            self.delegate?.makeButtonInactive()
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - setup image in photoImageView
extension PhotoView {

    private func setupPhoto(_ data: Data) {
        let photo = UIImage(data: data)
        self.photoImageView.image = photo
        self.photoImageView.contentMode = .scaleAspectFill
    }

    private func setupDefaultImage(imageName: String) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.photoViewDefaultImagePointSize,
                                                      weight: .medium)
        let photo = UIImage(systemName: imageName, withConfiguration: imageConfig)?
            .withTintColor(.systemGray3, renderingMode: .alwaysOriginal)

        photoImageView.image = photo
    }
}

// MARK: - AutoSave Photo
extension PhotoView {

    private func save(photo: UIImage) {
        guard let data = photo.pngData() else { return }
        viewModel.savePhoto(data)
    }
}

// MARK: - Hierarchy & layout
extension PhotoView {

    private func setupView() {
        configureHierarchy()
        configureLayout()
    }

    private func configureHierarchy() {
        self.addSubview(photoImageView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor)
        ])
    }
}
