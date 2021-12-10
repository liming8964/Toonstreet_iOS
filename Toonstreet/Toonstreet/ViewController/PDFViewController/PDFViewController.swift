//
//  PDFViewController.swift
//  Toonstreet
//
//  Created by Kavin Soni on 24/11/21.
//

import UIKit
import PDFKit
import WebKit
import FirebaseStorage
import SDWebImage

class PDFViewController: BaseViewController {

    
    var episodeList:[String]?
    var bookTitle:String?
    var selectedIndex:Int = 0
    
    @IBOutlet weak var webKit: WKWebView!
    @IBOutlet weak var imgComic: UIImageView!

    @IBOutlet weak var btnPrevious:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    
    @IBOutlet weak var viewPDF: UIView!
//    var pdfView:PDFView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.leftBarButtonItems = [.BackArrow]


//        self.setupPDFView()
        self.setupGesture()
        self.imgComic.enableZoom()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
    }
    
    
    
//    private func setupPDFView(){
//        // Add PDFView to view controller.
//        pdfView = PDFView(frame: CGRect.init(x: 0, y: 0, width: self.viewPDF.frame.width, height: self.viewPDF.frame.height))
//        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.viewPDF.addSubview(pdfView)
//
//
//
//        let fileURL = Bundle.main.url(forResource: "testcomic", withExtension: "pdf")
//        pdfView.displayMode = .singlePageContinuous
//        pdfView.autoScales = true
//        pdfView.displayDirection = .horizontal
//        pdfView.document = PDFDocument(url: fileURL!)
//        pdfView.goToFirstPage(nil)
//        pdfView.isUserInteractionEnabled = false
//
//        self.updateButtonViewUI()
//
//    }
    private func setupGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.viewPDF.addGestureRecognizer(swipeRight)
        self.imgComic.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        self.viewPDF.addGestureRecognizer(swipeLeft)
        self.imgComic.addGestureRecognizer(swipeLeft)

    }
    private func updateButtonViewUI(){
        if selectedIndex == 0{
            self.btnPrevious.isEnabled = false
        }else{
            self.btnPrevious.isEnabled = true
        }
        
        if selectedIndex == self.episodeList?.count ?? 0 - 1{
            self.btnNext.isEnabled = false
        }else{
            self.btnNext.isEnabled = true
        }
        
//        if pdfView.canGoToPreviousPage{
//            self.btnPrevious.isEnabled = true
//        }
//        else {
//            self.btnPrevious.isEnabled = false
//        }
//        if pdfView.canGoToNextPage{
//            self.btnNext.isEnabled = true
//
//        }else {
//            self.btnPrevious.isEnabled = false
//        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left:
                    print("Swiped Left")
//                    if pdfView.canGoToNextPage {
//                        pdfView.goToNextPage(nil)
//                    }
                    
                    selectedIndex = selectedIndex + 1

                        if selectedIndex < self.episodeList?.count ?? 0{

                            
                            if episodeList?.count ?? 0 > 0{

                            let storage = Storage.storage()
                            let starsRef = storage.reference(forURL: episodeList?[selectedIndex] ?? "")
                             
                            starsRef.downloadURL { url, error in
                              if let error = error {
                                // Handle any errors
                                  print(error)
                              } else {
                                // Get the download URL for 'images/stars.jpg'
                             
                                  if (url != nil) {
                                      self.imgComic.sd_setImage(with: url, completed: nil)
                                  }
                              }
                            }
                            }

                        }else{ selectedIndex = selectedIndex - 1}
                    updateButtonViewUI()

                    
                case UISwipeGestureRecognizer.Direction.right:
                    print("Swiped right")
                    
                    if selectedIndex > 0 {
                        selectedIndex = selectedIndex - 1
                        
                        if episodeList?.count ?? 0 > 0{

                        let storage = Storage.storage()
                        let starsRef = storage.reference(forURL: episodeList?[selectedIndex] ?? "")
                         
                        starsRef.downloadURL { url, error in
                          if let error = error {
                            // Handle any errors
                              print(error)
                          } else {
                            // Get the download URL for 'images/stars.jpg'
                         
                              if (url != nil) {
                                  self.imgComic.sd_setImage(with: url, completed: nil)
                              }
                          }
                        }
                        }

                        
                    }
                   
                    updateButtonViewUI()
//                    if pdfView.canGoToPreviousPage {
//                        pdfView.goToPreviousPage(nil)
//                    }
                default:
                    break
                }
            }
        }
    
    override func viewDidAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        
        self.navigationController?.navigationBar.topItem?.title = bookTitle ?? ""

        
        if episodeList?.count ?? 0 > 0{

        let storage = Storage.storage()
        let starsRef = storage.reference(forURL: episodeList?[0] ?? "")
         
        starsRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
         
              if (url != nil) {
                  self.imgComic.sd_setImage(with: url, completed: nil)
              }
          }
        }
        }
        
    }
    
    
    @IBAction func btnPreviousClick(_ sender: Any) {
        
        if selectedIndex > 0 {
            selectedIndex = selectedIndex - 1
        }
        
        if episodeList?.count ?? 0 > 0{

        let storage = Storage.storage()
        let starsRef = storage.reference(forURL: episodeList?[selectedIndex] ?? "")
         
        starsRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
         
              if (url != nil) {
                  self.imgComic.sd_setImage(with: url, completed: nil)
              }
          }
        }
        }
        updateButtonViewUI()
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        
        selectedIndex = selectedIndex + 1

        if selectedIndex < self.episodeList?.count ?? 0 {
        
        
        if episodeList?.count ?? 0 > 0{

        let storage = Storage.storage()
        let starsRef = storage.reference(forURL: episodeList?[selectedIndex] ?? "")
         
        starsRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
         
              if (url != nil) {
                  self.imgComic.sd_setImage(with: url, completed: nil)
              }
          }
        }
        }
        }else{
            selectedIndex = selectedIndex - 1
        }
        updateButtonViewUI()
    }
    
    
    
}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
