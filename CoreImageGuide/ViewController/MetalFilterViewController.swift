//
//  MetalFilterViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit
import Metal
import MetalKit

class MetalFilterViewController: UIViewController {
    
    var filter: CIFilter?
    
    var device: MTLDevice?
    var commandQueue: MTLCommandQueue?
    
    var metalView: MTKView?
    var sourceTexture: MTLTexture?
    
    var context: CIContext?
    
    var colorSpace: CGColorSpace?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.white
        title = "Metal渲染图片滤镜"
        filter = CIFilter(name: "CIGaussianBlur")
        colorSpace = CGColorSpaceCreateDeviceRGB()
        
        device = MTLCreateSystemDefaultDevice()
        commandQueue = device?.makeCommandQueue()
        
        metalView?.delegate = self
        metalView?.device = device
        metalView?.framebufferOnly = false
        
        context = CIContext(mtlDevice: device!)
    }

}

extension MetalFilterViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        let commandBuffer = commandQueue?.makeCommandBuffer()
        
        guard let drawable = view.currentDrawable else { return }
        
        let inputImage = CIImage(mtlTexture: sourceTexture!)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(100, forKey: kCIInputRadiusKey)
        
        context?.render((filter?.outputImage)!, to: view.depthStencilTexture!, commandBuffer:commandBuffer , bounds: inputImage!.extent, colorSpace: colorSpace!)
        
        commandBuffer?.present(drawable)
        commandBuffer!.commit()
        
    }
}
