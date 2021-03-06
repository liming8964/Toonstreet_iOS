//
//  HomeViewController.swift
//  Toonstreet
//
//  Created by Kavin Soni on 20/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
//import FirebaseStorageUI
import FirebaseFirestoreSwift


class HomeViewController: BaseViewController {

    var objReadingDict:NSDictionary = NSDictionary()
//    var viewControllerToInsertBelow : UIViewController?



    var arrComics:[TSBook] = []
//    var arrUpdate:[TSBook] = []
    var arrNewRelease:[TSBook] = []

    //MARK: - IBOutlet
    @IBOutlet weak var tblHomeTableView:HomeTableView!
    @IBOutlet weak var mainView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        TSFirebaseAPI.shared.getUserData()

        
//        self.fetchComicData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: Setup UI
     override func setupUI(){
        
         self.mainView.backgroundColor = UIColor.Theme.themeBlackColor
         self.view.backgroundColor = UIColor.Theme.themeBlackColor
        
          
         self.tblHomeTableView.blockClickAllButton = { [weak self] (homeType) in

             self?.openAllComicScreen(type: homeType)
            
         }
         
         self.tblHomeTableView.didSelectCellItem { [weak self] (type, book) in
             
             if type == .ResumeReading {
                 self?.openDetailScreen(book: book, isPass: false)//true

             }else{
                 self?.openDetailScreen(book: book, isPass: false)

             }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        TSFirebaseAPI.shared.checkComicReadingAvailability(completion: { [unowned self] available in
            
            if available == true{
                self.fetchComicData()
                self.tblHomeTableView.setTableViewData(isContinueReading: false)

            }else{
                self.fetchContinueReadingData()
                self.tblHomeTableView.setTableViewData(isContinueReading: true)

            }
            
        })
    }
    
    private func openAllComicScreen(type:HomeType){
        if let objDetailView = self.storyboard?.instantiateViewController(withIdentifier: "AllEpisodeViewController") as? AllEpisodeViewController{
//            objDetailView.arrComics = books
            objDetailView.type = type
//            self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(objDetailView, animated: true)
        }
    }
    private func openDetailScreen(book:TSBook , isPass:Bool){
//        print("Data")
            
        
        
        if isPass == true{
            if let objDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
                
                let purchasedDict1 =  TSFirebaseAPI.shared.arrPurchasedComicDict.filter({$0.value(forKey: "title" ) as? String == book.title})

                if purchasedDict1.count>0{
                let objBook1 = TSBook.init(dictObj: purchasedDict1[0])
                    objDetailView.objBook = objBook1
                    objDetailView.objReadingDict = self.objReadingDict.value(forKey: book.title) as? NSDictionary
//                    self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true

//                        self.navigationController?.pushViewController(objDetailView, animated: true)
                }else{
                    objDetailView.objBook = book
                    objDetailView.objReadingDict = self.objReadingDict.value(forKey: book.title) as? NSDictionary
                }
                

            
            if let objPDFVC = self.storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as? PDFViewController{
                
                objPDFVC.selectedComic = book
                objPDFVC.bookTitle = book.title
//                objPDFVC.selectedEpisode = book

                if let dictTitle = self.objReadingDict.value(forKey: book.title) as? NSDictionary {
                   
                    if let arrEpisod = dictTitle["episode"] as? [String]{
                        objPDFVC.episodeList = arrEpisod
                    }else{
                        objPDFVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

                        self.navigationController?.present(objPDFVC, animated: true, completion: nil)

//                        self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(objDetailView, animated: true)
                        return
                    }
               
                    if let index = dictTitle["index"] as? Int {
                        objPDFVC.passIndex = index
                    }else if let index = dictTitle["index"] as? String {
                        objPDFVC.passIndex = Int(index) ?? 0
                    }
                }else{
                    objPDFVC.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

                    self.navigationController?.present(objPDFVC, animated: true, completion: nil)

//                    self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true

//                    self.navigationController?.pushViewController(objDetailView, animated: true)
                    return
                }
               
                            
                
                if var navstack = navigationController?.viewControllers{
                        navstack.append(contentsOf: [objDetailView])//objPDFVC
                    navstack.last?.present(objPDFVC, animated: true, completion: nil)
//                        navigationController?.setViewControllers(navstack, animated: true)
                }
            }
            }
        }else{
                
                if let objDetailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController{
                    
                    let purchasedDict1 =  TSFirebaseAPI.shared.arrPurchasedComicDict.filter({$0.value(forKey: "title" ) as? String == book.title})

                    if purchasedDict1.count>0{
                    let objBook1 = TSBook.init(dictObj: purchasedDict1[0])
                        objDetailView.objBook = objBook1
                        objDetailView.objReadingDict = self.objReadingDict.value(forKey: book.title) as? NSDictionary
//                        self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(objDetailView, animated: true)
                    }else{
                        objDetailView.objBook = book
                        objDetailView.objReadingDict = self.objReadingDict.value(forKey: book.title) as? NSDictionary
//                        self.navigationController?.tabBarController?.hidesBottomBarWhenPushed = true

                            self.navigationController?.pushViewController(objDetailView, animated: true)
                    }
                }
        }
     
    }
    
    
    func fetchContinueReadingData(){
        
//        TSFirebaseAPI.shared.arrPurchasedComic = []
        
        TSFirebaseAPI.shared.fetchPurchaseData { [unowned self] status in
            TSFirebaseAPI.shared.fetchContinueReadingData { [unowned self] dict in
                self.objReadingDict = dict
                self.fetchComicData()
            }
        }
        self.fetchComicData()

//        let ref = Database.database().reference(fromURL: FirebaseBaseURL)

//        _ = ref.child("ContinueReading").child(TSUser.shared.uID).observeSingleEvent(of: .value, with: { (snapshot) in
//                                               print(snapshot)
//                                               self.listReadComic = []
//                                               guard let value = snapshot.value else { return }
//
//
//                                               if let arrValue = value as? NSDictionary {
//
//                                                   self.objReadingDict = arrValue;
//
//                                                   for strKey in arrValue.allKeys{
//                                                       self.listReadComic.append(strKey as? String ?? "")
//                                                   }
////                                                   self.listReadComic = arrValue.allKeys
//                                                   self.fetchComicData()
//                                               }
//                                           })
        
        
    }
    
    
    func fetchComicData(){

//        TSFirebaseAPI.shared.arrPurchasedComic = []
        TSFirebaseAPI.shared.arrContinueReading = []
                                           
        self.arrComics = []

        TSFirebaseAPI.shared.fetchPopularData { [unowned self] arrBook in
            
            self.arrComics = arrBook

            self.tblHomeTableView.setAndReloadTableViewComics(arr: self.arrComics, arrContinueReading: TSFirebaseAPI.shared.arrContinueReading)
            
        }
       
        
        self.arrNewRelease = []
        
        TSFirebaseAPI.shared.fetchNewReleaseData { [unowned self] arrBook in
            self.arrNewRelease = arrBook
            self.tblHomeTableView.setAndReloadTableViewNewRelease(arr: self.arrNewRelease, arrContinueReading: TSFirebaseAPI.shared.arrContinueReading)
        }
    }
    
    
    func fetchPurchasedData(){
        
        
        
        TSFirebaseAPI.shared.fetchContinueReadingData { [unowned self] dict in
            self.objReadingDict = dict
            self.fetchComicData()
        }
        
    }
    
}


extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}
extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}
