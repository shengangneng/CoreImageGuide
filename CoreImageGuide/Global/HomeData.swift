//
//  HomeData.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import Foundation

struct HomeData {
    static let titleList = [
        // 基本使用
        ["header":"图像处理", "item":[
            ["BasicFilterGuideViewController", "滤镜基本使用", "需要注意的是CIContext是重量级对象，应该进行复用"],
            ["CombineFilterViewController", "合并滤镜", "需要注意的是CIContext是重量级对象，应该进行复用"],
            ["VideoFilterViewController", "视频使用滤镜", "使用AVVideoComposition对象在播放或导出期间将Core Image滤镜应用于视频的每一帧"],
            ["MetalFilterViewController", "Metal渲染图片滤镜", "使用MetalKit试图（MTKView）渲染Core Image输出图像"]
        ]],
        // 脸部检测
        ["header":"人脸检测", "item":[
            ["BasicFilterGuideViewController", "检测脸部特征", "CIDetector类在图像中查找脸部并分析特征"],
            ["BasicFilterGuideViewController", "检测矩形及其特征", "CIDetector类在图像中查找脸部并分析特征"],
        ]],
        // 自动增强图像
        ["header":"自动增强图像", "item":[
            ["BasicFilterGuideViewController", "图像自动增强滤镜", "不必立即应用自动调整滤镜，可以保存滤镜名和参数值以供日后使用。保存他们可让您的应用程序稍后执行增强功能，而无需再次分析图像"],
        ]],
        
        
        // 查询滤镜
        ["header":"查询滤镜", "item":[
            ["BasicFilterGuideViewController", "构建滤镜列表", "通过获取滤镜和属性列表来构建滤镜字典"],
        ]],
        
        // 使用反馈处理图像
        ["header":"使用反馈处理图像", "item":[
            ["BasicFilterGuideViewController", "绘画小程序", "MicroPaint"],
        ]],
        
        // 子类化CIFilter自定义特效
        ["header":"子类化CIFilter自定义特效", "item":[
            ["BasicFilterGuideViewController", "反转图像颜色", "CIColorInvert滤镜"],
            ["BasicFilterGuideViewController", "色度键控制合成图像", "CIChromaKey滤镜"],
            ["BasicFilterGuideViewController", "面部虚化", "CIFaceVignette滤镜"],
            ["BasicFilterGuideViewController", "线性聚焦", "CILiearFocus滤镜"],
            ["BasicFilterGuideViewController", "面部马赛克", "CIAnonymousFaces滤镜"],
            ["BasicFilterGuideViewController", "马赛克作为图片过渡", "CIPixellateTransition滤镜"],
            ["BasicFilterGuideViewController", "老胶片效果", "CIOldFile滤镜"]
        ]],
    ]
}
