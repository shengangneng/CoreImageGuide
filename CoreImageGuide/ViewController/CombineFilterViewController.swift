//
//  CombineFilterViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit

class CombineFilterViewController: BaseCameraAndPhotoViewController {
    
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
        button.addTarget(self, action: #selector(cbReset), for: .touchUpInside)
        return button
    }()
    
    lazy var colorFilterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("颜色滤镜", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(colorFilter), for: .touchUpInside)
        return button
    }()
    
    lazy var bloomFilterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发光滤镜", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(bloomFilter), for: .touchUpInside)
        return button
    }()
    
    lazy var addFilterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("颜色+发光", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(colorAndBloomFilter), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupSubViews()
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.white
        title = "合并滤镜"
        let barButton = UIBarButtonItem(title: "图片", style: .plain, target: self, action: #selector(cbChooseImage))
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setupSubViews() {
        view.addSubview(imageView)
        view.addSubview(resetButton)
        view.addSubview(colorFilterButton)
        view.addSubview(bloomFilterButton)
        view.addSubview(addFilterButton)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.height.equalTo(Marcon.kSceneImageH)
        }
        let buttonW = 100
        let buttonH = 35
        resetButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(buttonH)
            make.leading.equalTo(self.view.snp.leading)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
        colorFilterButton.snp.makeConstraints { make in
            make.width.equalTo(buttonW)
            make.height.equalTo(buttonH)
            make.leading.equalTo(self.resetButton.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
        bloomFilterButton.snp.makeConstraints { make in
            make.width.equalTo(buttonW)
            make.height.equalTo(buttonH)
            make.leading.equalTo(self.colorFilterButton.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
        addFilterButton.snp.makeConstraints { make in
            make.width.equalTo(buttonW + 10)
            make.height.equalTo(buttonH)
            make.leading.equalTo(self.bloomFilterButton.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom).offset(-UIDevice.safeDistanceBottom())
        }
    }
}

extension CombineFilterViewController {
    
    @objc private func cbChooseImage() {
        cameraAndAlbum { image in
            self.originalImage = image
            self.imageView.image = image
        }
    }
    
    @objc private func cbReset() {
        imageView.image = originalImage
    }
    
    @objc private func colorFilter() {
        guard let source = CIImage(image: originalImage!) else { return }
        let filter = CIFilter(name: "CIPhotoEffectProcess", parameters: [kCIInputImageKey:source])
        
        let context = CIContext()
        guard let outputImage = filter?.outputImage else { return }
        guard let cgimage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiimage =  UIImage(cgImage: cgimage, scale: 1, orientation: originalImage!.imageOrientation)
        
        imageView.image = uiimage
    }
    
    @objc private func bloomFilter() {
        guard let source = CIImage(image: originalImage!) else { return }
        let filter = CIFilter(name: "CIBloom", parameters: [kCIInputImageKey:source.clampedToExtent(), kCIInputIntensityKey:0.9, kCIInputRadiusKey:10])
        
        let context = CIContext()
        guard let outputImage = filter?.outputImage else { return }
        guard let cgimage = context.createCGImage(outputImage.cropped(to: source.extent), from: source.extent) else { return }
        let uiimage =  UIImage(cgImage: cgimage, scale: 1, orientation: originalImage!.imageOrientation)
        
        imageView.image = uiimage
    }
    
    @objc private func colorAndBloomFilter() {
        guard let source = CIImage(image: originalImage!) else { return }
        let filter = CIFilter(name: "CIPhotoEffectProcess", parameters: [kCIInputImageKey:source])
        
        guard let outputImage = filter?.outputImage else { return }
        let crop = outputImage.clampedToExtent()
        let ciimage = crop.applyingFilter("CIBloom", parameters: [kCIInputIntensityKey:0.9, kCIInputRadiusKey:10])
        let context = CIContext()
        guard let cgimage = context.createCGImage(ciimage.cropped(to: source.extent), from: source.extent) else { return }
        let uiimage =  UIImage(cgImage: cgimage, scale: 1, orientation: originalImage!.imageOrientation)
        
        imageView.image = uiimage
    }

}
