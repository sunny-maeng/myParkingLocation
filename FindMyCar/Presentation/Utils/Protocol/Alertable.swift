//
//  Alertable.swift
//  FindMyCar
//
//  Created by 써니쿠키 on 2023/03/28.
//

import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {

    func showAlert(title: String = "", massage: String = "", style: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)

        self.present(alert, animated: true)
    }

    func showLocationServiceRequestAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 권한 없음",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)

        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancel)
        present(requestLocationServiceAlert, animated: true)
    }

    func showCameraServiceRequestAlert() {
        let requestCameraServiceAlert = UIAlertController(
            title: "카메라 사용 권한 없음",
            message: "카메라를 사용할 수 없습니다.\n디바이스의 설정에서 카메라를 활성화 해주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)

        requestCameraServiceAlert.addAction(goSetting)
        requestCameraServiceAlert.addAction(cancel)
        present(requestCameraServiceAlert, animated: true)
    }
}
