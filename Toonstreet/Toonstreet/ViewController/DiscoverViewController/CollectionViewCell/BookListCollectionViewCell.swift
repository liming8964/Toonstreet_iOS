//
//  BookListCollectionViewCell.swift
//  Toonstreet
//
//  Created by Kavin Soni on 21/11/21.
//

import UIKit
//import SDWebImage
import FirebaseStorage
import Combine

class BookListCollectionViewCell: UICollectionViewCell {
    static let identifer = "BookListCollectionViewCellIdentifier"
    
    private var subscriber: AnyCancellable?

    
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var imgViewProfile:UIImageView!
    @IBOutlet weak var lblTitle:TSLabel!
    @IBOutlet weak var lblType:TSLabel!
    
    
    var assetIdentifier: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//           self.contentView.autoresizingMask = flexibleHeight | flexibleWidth
        //UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
//        self.contentView.translatesAutoresizingMaskIntoConstraints = true;
           
        
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
//
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriber?.cancel()
        self.imgViewProfile?.image = UIImage(systemName: "dummy_image")
    }

    func setImage(to url: URL) {
        subscriber = TSImageManager.shared.imagePublisher(for: url, errorImage: UIImage(systemName: "dummy_image")).assign(to: \.self.imgViewProfile.image, on: self)
        
//              .assign(to: self.imgViewProfile.image ?? , on: self)
    }
  
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//
//    }
    func updateUI(withIsHideType isHide:Bool){
        self.lblType.isHidden = isHide
    }
    private func commonInit(){
        self.imgViewProfile.layer.cornerRadius = 10.0
        self.imgViewProfile.layer.masksToBounds = true
        
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.font = UIFont.font_extrabold(12.0)
        self.lblTitle.text = "Nanatsu no Taizai"
        
        
        self.lblType.textColor = UIColor.white
        self.lblType.font = UIFont.font_regular(10.0)
        self.lblType.text = "Fantasy, Shounen"
        
        self.mainView.backgroundColor = UIColor.clear
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func setupCellData(objBook:TSBook){

        self.lblTitle.text = objBook.title
        self.lblType.text = objBook.category
        
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
