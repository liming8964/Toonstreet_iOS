//
//  MyListTableViewCell.swift
//  Toonstreet
//
//  Created by Kavin Soni on 23/11/21.
//

import UIKit

typealias ProfileScreenMyListTableViewCellSelectionHandler = ((_ type:ProfileType, _ book:TSBook)->Void)

class MyListTableViewCell:TSTableViewCell {
    
    var arrComics:[TSBook] = []

    
    static let identifer = "MyListTableViewCell"

    
    @IBOutlet weak var lblTitle:TSLabel!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var viewCollection:UIView!
    
    @IBOutlet weak var myListCollectionView:MyListCollectionView!
    private var didSelectCellItem:ProfileScreenMyListTableViewCellSelectionHandler?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAndReloadTableView(arr:[TSBook]){
        self.arrComics = arr
        self.myListCollectionView.loadBooks(withBooks: self.arrComics)
//      self.myListCollectionView.reloadData()
    }
    
    func commonInit(){
        
        self.lblTitle.text = "My Lists"
        self.lblTitle.numberOfLines = 0
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.font = UIFont.appFont_Bold(Size: 20)
        self.mainView.backgroundColor = UIColor.Theme.themeBlackColor
        self.viewCollection.backgroundColor = UIColor.clear
        
        
//       self.myListCollectionView.loadBooks(withBooks: arrComics)
        
        self.myListCollectionView.setDidSelectPhotoHandler { [weak self] (aryBook, index) in
            
            if let value = self?.didSelectCellItem{
                value(ProfileType.MyList,self?.arrComics[index] ?? TSBook())
            }
        }
    }
    
    func didSelectCellItem(withHandler handler:ProfileScreenMyListTableViewCellSelectionHandler?){
        if let value = handler{
            self.didSelectCellItem = value
        }
    }
    
}
