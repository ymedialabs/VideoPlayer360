//
//  ProductVC.swift
//  360VideoPlayer
//
//  Created by Prianka Liz Kariat on 9/21/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import CoreMotion

class ProductVC: UIViewController {

  lazy var motionManager = CMMotionManager()
  
  let maxSecs: Double = 40.0
  
  var videos: [[String : String]] = []
  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
      
      videos.append(["fileName" : "shoe-4", "fileExtension" : "mp4", "productName" : "Trainers"])
      videos.append(["fileName" : "shoe-3", "fileExtension" : "mp4", "productName" : "High Heels"])
      videos.append(["fileName" : "shoe-2", "fileExtension" : "mp4", "productName" : "Sneakers"])
           
      tableView.reloadData()
      tableView.rowHeight = UITableViewAutomaticDimension
      navigationController?.navigationBar.tintColor = UIColor.black
      
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    
    startAttitudeObservation()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if segue.identifier == "ProductVC_VideoVC" {
        
        let videoVC = segue.destination as? VideoVC
        let cell = sender as? UITableViewCell
        
        if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
        let video = videos[indexPath.row]
        videoVC?.fileName = video["fileName"]
        videoVC?.fileExtension = video["fileExtension"]
        
          let backItem = UIBarButtonItem()
          backItem.title = ""
          navigationItem.backBarButtonItem = backItem
        }
        
      }
  
    }
  

}

extension ProductVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return videos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PRODUCT_CELL") as! ProductCell
    
    let video = videos[indexPath.row]

    if let videoPlayer = cell.videoPlayer {
      
      cell.scrollView.contentSize = CGSize(width: view.bounds.size.width * 2.0, height: 185.0)
      cell.duration = videoPlayer.durationOfVideo()
      cell.scrollView.tag = indexPath.row
      cell.scrollView.delegate = self
      
    }
    else {
      
      if let fileName = video["fileName"], let fileExtension = video["fileExtension"] {
        let videoPlayer = VideoPlayer(videoFileName: fileName, videoFileType: fileExtension)
        videoPlayer.setUpPlayerInView(view: cell.playerView)
        cell.videoPlayer = videoPlayer
        cell.scrollView.contentSize = CGSize(width: view.bounds.size.width * 2.0, height: 185.0)
        cell.scrollView.tag = indexPath.row
        cell.duration = videoPlayer.durationOfVideo()
        cell.scrollView.delegate = self
      }
      cell.productNameLabel.text = video["productName"]

    }
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      let cell = tableView.cellForRow(at: indexPath)
      performSegue(withIdentifier: "ProductVC_VideoVC", sender: cell)
  }
 
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 200
  }
  
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let row = scrollView.tag
    guard scrollView != tableView  else{
      
      return
    }
    
    guard case 0...9 = scrollView.tag else {
      
      return
    }
    
    print(row)
    let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? ProductCell
    
    guard let productCell = cell else {
      
      return
    }
    let contentOffsetX =  scrollView.contentOffset.x
  
    
    var seekDuration: Double = 0.0
    
    if contentOffsetX >= 0 && contentOffsetX <= view.frame.size.width * 2.0 {
      
      seekDuration = (Double(contentOffsetX) * productCell.duration) / Double(view.bounds.size.width)
      if !productCell.isSeeking {
        
        productCell.isSeeking = true
        productCell.videoPlayer?.seekToTime(duration: seekDuration, complationHandler: { (complete) in
          productCell.isSeeking = false
          })
      }
    }
  }
}

extension ProductVC {
  
  func startAttitudeObservation() {
    
    motionManager.deviceMotionUpdateInterval = 0.0
    motionManager.startDeviceMotionUpdates(to: OperationQueue.main) {[weak self] (deviceMotion, error) in
      
      if let roll = deviceMotion?.attitude.roll, let viewController = self {
        
        for cell in viewController.tableView.visibleCells {
          
          if let productCell = cell as? ProductCell , productCell.videoPlayer != nil {
            let rollDegrees = viewController.radiansToDegrees(rad: roll)
            
            if productCell.isSeeking == false {
              
              productCell.isSeeking = true
              
              let degress = (180.0 * productCell.duration) / (viewController.maxSecs/2.0)
              
              let seekDuration = (rollDegrees * productCell.duration) / degress
              
              productCell.videoPlayer?.seekToTime(duration: seekDuration, complationHandler: { (complete) in
                
                let contentOffSetX =  CGFloat((seekDuration * Double(viewController.view.bounds.size.width)) / productCell.duration)
                productCell.scrollView.contentOffset = CGPoint(x: contentOffSetX, y: 0.0)
                productCell.isSeeking = false
              })
            }
          }
        }
        
      }
      
    }
    
  }
  
  func radiansToDegrees(rad: Double) -> Double {
    
    return (180 * rad)/M_PI
  }
}

