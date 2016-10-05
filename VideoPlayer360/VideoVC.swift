//
//  VideoVC.swift
//  360VideoPlayer
//
//  Created by Prianka Liz Kariat on 9/22/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

    var fileName: String?
    var fileExtension: String?
  
    var videoPlayer: VideoPlayer?
    var duration: Double = 0.0
    var isSeeking = true
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var playerView: PlayerView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let fileName = fileName , let fileExtension = fileExtension {
        
        videoPlayer = VideoPlayer(videoFileName: fileName, videoFileType: fileExtension)
        scrollView.contentSize = CGSize(width: view.bounds.size.width * 2.0, height: view.frame.size.height)
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
      }

      // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    videoPlayer?.setUpPlayerInView(view: playerView)
    isSeeking = false
    
    if let videoPlayer = videoPlayer {
      duration = videoPlayer.durationOfVideo()
    }
    scrollView.delegate = self
    
  }
}

extension VideoVC: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let contentOffsetX =  scrollView.contentOffset.x
    
    var seekDuration: Double = 0.0
    
    if contentOffsetX >= 0 && contentOffsetX <= view.frame.size.width * 2.0 {
      
      seekDuration = (Double(contentOffsetX) * duration) / Double(view.bounds.size.width)
      if !isSeeking {
        
        isSeeking = true
        videoPlayer?.seekToTime(duration: seekDuration, complationHandler: {[weak self] (complete) in
          self?.isSeeking = false
          })
      }
      
    }
  }
}
