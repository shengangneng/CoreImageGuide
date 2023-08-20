//
//  VideoFilterViewController.swift
//  CoreImageGuide
//
//  Created by shengangneng on 2023/7/23.
//

import UIKit
import AVFoundation

class VideoFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
    }
    
    private func setupAttributes() {
        view.backgroundColor = UIColor.white
        title = "视频添加滤镜"
        guard let res = Bundle.main.path(forResource: "originVideo", ofType: "mov") else { return }
        let ass = AVAsset(url: URL(fileURLWithPath: res))
        var item = AVPlayerItem(asset: ass)
        
        let player1 = AVPlayer(playerItem: item)
        let playerLayer1 = AVPlayerLayer(player: player1)
        view.layer .addSublayer(playerLayer1)
        playerLayer1.frame = CGRectMake(0, 100, Marcon.kScreenWidth, 300)
        
        item = AVPlayerItem(asset: ass)
        let filter = CIFilter(name: "CIGaussianBlur")
        let composition = AVVideoComposition(asset: ass) { request in
            let ciimage = request.sourceImage.clampedToExtent()
            filter?.setValue(ciimage, forKey: kCIInputImageKey)
            
            let seconds = CMTimeGetSeconds(request.compositionTime)
            filter?.setValue(seconds, forKey: kCIInputRadiusKey)
            guard let output = filter?.outputImage else { return }
            
            let outputImage = output.cropped(to: ciimage.extent)
            request.finish(with: outputImage, context: nil)
        }
        item.videoComposition = composition
        
        let player2 = AVPlayer(playerItem: item)
        let playerLayer2 = AVPlayerLayer(player: player2)
        view.layer .addSublayer(playerLayer2)
        playerLayer2.frame = CGRectMake(0, 400, Marcon.kScreenWidth, 300)
        
        player1.play()
        player2.play()
    }
    
    private func setupSubViews() {
        
    }
    

}
