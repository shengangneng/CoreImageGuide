//
//  BaseCameraAndPhotoViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit
import Photos

class BaseCameraAndPhotoViewController: UIViewController {
    var closure: ((_ image: UIImage) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseCameraAndPhotoViewController: UINavigationControllerDelegate,
                                            UIImagePickerControllerDelegate {
    
    func cameraAndAlbum(_ handler: @escaping (_ image: UIImage) -> Void) {
        closure = handler
        let alert = UIAlertController(title: "图片来源", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "相机", style: .default) { _ in
            let type = AVCaptureDevice.authorizationStatus(for: .video)
            if type == .restricted || type == .denied {
                // setting
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async() {
                            if granted {
                                let controller = UIImagePickerController()
                                controller.allowsEditing = false
                                controller.delegate = self
                                controller.sourceType = .camera
                                self .present(controller, animated: true)
                            } else {
                                // setting
                            }
                        }
                    }
                } else {
                    let controller = UIAlertController(title: "提示", message: "设备没有相机", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self .present(controller, animated: true)
                }
            }
        }
        alert.addAction(cameraAction)
        
        let photoAction = UIAlertAction(title: "相册", style: .default) { _ in
            
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .restricted || status == .denied {
                // setting
            } else {
                PHPhotoLibrary.requestAuthorization { sts in
                    DispatchQueue.main.async() {
                        if sts == .authorized {
                            let controller = UIImagePickerController()
                            controller.allowsEditing = false
                            controller.delegate = self
                            controller.sourceType = .photoLibrary
                            self .present(controller, animated: true)
                        } else {
                            // setting
                        }
                    }
                }
            }
        }
        alert.addAction(photoAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancelAction)
        
        self .present(alert, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (picker.allowsEditing ? info[.editedImage] : info[.originalImage]) else {
            picker .dismiss(animated: true)
            return
        }
        if closure != nil {
            closure!(image as! UIImage)
        }
        picker .dismiss(animated: true)
    }
    
}
