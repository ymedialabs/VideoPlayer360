//
//  VideoPlayer.swift
//  360VideoPlayer
//
//  Created by Prianka Liz Kariat on 9/20/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoPlayer : NSObject {
 
  private var videoUrl : URL!
  private var player: AVPlayer?
  
  init(videoFileName: String, videoFileType: String) {
    
    videoUrl = Bundle.main.url(forResource: videoFileName, withExtension: videoFileType)
    super.init()
  }
  
  func setUpPlayerInView(view: UIView) {
    
    guard videoUrl != nil && player == nil else {
      
      return
    }
    
    let avPlayerItem = AVPlayerItem(url: videoUrl)
    player = AVPlayer(playerItem: avPlayerItem)
    
   // let  playerLayer = AVPlayerLayer(player: player)
   // playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
    
  //  playerLayer.frame = view.frame
    
    let playerLayer = view.layer as! AVPlayerLayer
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    playerLayer.player = player
   // view.layer.addSublayer(playerLayer)
    
  }
  
  func play() {
    player?.play()
  }
  
  func pauseVideo() {
    
    if player?.rate != 0 {

      player?.pause()
    }
  }
  
  func seekToTime(duration: Double, complationHandler: @escaping (Bool) -> Void) {
    
    if let currentItem = player?.currentItem {
      let time = CMTimeMakeWithSeconds(duration, currentItem.asset.duration.timescale)
      
      player?.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (complete) in
        
        DispatchQueue.main.async {
          
          complationHandler(complete)

        }
        
      })
    }
  }
  
  func durationOfVideo() -> Double {
    
    guard let currentItem = player?.currentItem else {

      return 0.0
    }
    
    return CMTimeGetSeconds(currentItem.asset.duration)
  }

}
