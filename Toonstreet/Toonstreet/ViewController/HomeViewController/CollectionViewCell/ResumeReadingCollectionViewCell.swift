//
//  ResumeReadingCollectionViewCell.swift
//  Toonstreet
//
//  Created by Kavin Soni on 20/11/21.
//

import UIKit
import FirebaseStorage
//import SDWebImage
import Combine

class ResumeReadingCollectionViewCell: UICollectionViewCell {
    static let identifer = "ResumeReadingCollectionViewCellIdentifier"
    
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var lblTitle:TSLabel!
    @IBOutlet weak var lblAuthor:TSLabel!
    
    private var subscriber: AnyCancellable?

    
    var assetIdentifier: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    private func commonInit(){
        self.imgViewProfile.layer.cornerRadius = 14.0
        self.imgViewProfile.layer.masksToBounds = true
        
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.font = UIFont.font_extrabold(16.0)
        self.lblTitle.text = "Blush-DC: Himitsu"
        
        
        self.lblAuthor.textColor = UIColor.white
        self.lblAuthor.font = UIFont.font_regular(14.0)
        self.lblAuthor.text = "Romance"
        
        self.mainView.backgroundColor = UIColor.clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriber?.cancel()
        self.imgViewProfile?.image = UIImage(systemName: "dummy_image")
    }

    func setImage(to url: URL) {
        subscriber = TSImageManager.shared.imagePublisher(for: url, errorImage: UIImage(systemName: "dummy_image")).assign(to: \.self.imgViewProfile.image, on: self)
        
//              .assign(to: self.imgViewProfile.image ?? , on: self)
    }
  
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        self.imgViewProfile.image = UIImage()
//        self.imgViewProfile.image = UIImage.init(named: "dummy_image")
////        self.imgViewProfile.sd_cancelCurrentImageLoad()
////        self.imgViewProfile.image = nil
//        self.imgViewProfile.sd_cancelCurrentImageLoad()
//
//    }
    
    func setupCellData(objBook:TSBook){

        self.lblTitle.text = objBook.title
        self.lblAuthor.text = objBook.category
        
        if objBook.cover != ""{
        let storage = Storage.storage()
        let starsRef = storage.reference(forURL: objBook.cover)

//         Fetch the download URL
        starsRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
              print(error)
          } else {
            // Get the download URL for 'images/stars.jpg'
              if (url != nil) {
                  self.setImage(to: url!)
              }
              
              //              self.imgViewProfile.sd_setImage(with: url, completed: nil)
//              self.imgViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.white
//              self.imgViewProfile.sd_setImage(with: url, placeholderImage: UIImage(named: ""))

//              SDWebImageManager.shared.loadImage(
//                with: url,//.(imageShape: .square),
//                  options: .handleCookies, // or .highPriority
//                  progress: nil,
//                  completed: { [weak self] (image, data, error, cacheType, finished, url) in
//                      guard let sself = self else { return }
//
//                      if let err = error {
//                          // Do something with the error
//                          return
//                      }
//
//                      guard let img = image else {
//                          // No image handle this error
//                          return
//
//                      }
//                      self?.imgViewProfile.image = img
//
//                  }
//              )
          }
        }
        }
    }
}
