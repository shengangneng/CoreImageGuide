//
//  BasicFilterGuideViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit

class BasicFilterGuideViewController: BaseCameraAndPhotoViewController {
    
    var originalImage = UIImage(named: "scene.jpeg")
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView(image: originalImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var resetButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("重置", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    lazy var addFilterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("添加滤镜", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addFilter), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupSubViews()
    }
    
    private func setupKVO() {
        
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.white
        title = "滤镜的基本使用"
        let barButton = UIBarButtonItem(title: "图片", style: .plain, target: self, action: #selector(chooseImage))
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setupSubViews() {
        view.addSubview(imageView)
        view.addSubview(resetButton)
        view.addSubview(addFilterButton)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(Marcon.kSceneImageH)
        }
        resetButton.snp.makeConstraints { make in
            make.width.equalTo(Marcon.kScreenWidth / 2)
            make.height.equalTo(35)
            make.leading.equalTo(self.view.snp.leading)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
        addFilterButton.snp.makeConstraints { make in
            make.width.equalTo(Marcon.kScreenWidth / 2)
            make.height.equalTo(35)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
    }
}

extension BasicFilterGuideViewController {
    
    @objc private func chooseImage() {
        cameraAndAlbum { image in
            self.originalImage = image
            self.imageView.image = image
        }
    }
    
    @objc private func reset() {
        imageView.image = originalImage
    }
    
    @objc private func addFilter() {
        addFilterToImage()
    }
    
    private func addFilterToImage() {
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(0.9, forKey: kCIInputIntensityKey)
        let source = CIImage(image: self.originalImage!)
        filter?.setValue(source, forKey: kCIInputImageKey)
        
        let context = CIContext()
        guard let ciimage = filter?.outputImage?.cropped(to: source?.extent ?? CGRectZero) else {return }
        guard let cgimage = context.createCGImage(ciimage, from: source?.extent ?? CGRectZero) else { return }
        let uiimage =  UIImage(cgImage: cgimage, scale: 1, orientation: originalImage!.imageOrientation)
        
        imageView.image = uiimage
    }
}
