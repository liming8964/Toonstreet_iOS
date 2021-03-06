//
//  LoginViewController.swift
//  Toonstreet
//
//  Created by Kavin Soni on 18/11/21.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {

    
    //VARIABLE
    var btnEye = UIButton(type: .custom)
//    private let validationService:ValidationService
    var isShowPassword:Bool = false

    @IBOutlet weak var txtViewSignupButton:UILabel!

    @IBOutlet weak var lblStaticUser: TSLabel!
    @IBOutlet weak var lblStaticPassword: TSLabel!
    @IBOutlet weak var txtUsername: TSTextField!
    @IBOutlet weak var txtPassword: TSTextField!

    @IBOutlet weak var btnLogin: TSButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Setup UI
    override func setupUI(){
        self.txtUsername.keyboardType = .emailAddress
        self.txtPassword.isSecureTextEntry = true
        self.txtUsername.leftViewImage = UIImage.init(named: "icon")
        self.txtPassword.leftViewImage = UIImage.init(named: "lock")
        self.view.backgroundColor = UIColor.Theme.themeBlackColor
        self.setPasswordVisableMethod()
        self.setupTextView()
    }

    
    //MARK: Password visable methods
    func setPasswordVisableMethod(){
        btnEye.setImage(UIImage(named: "eye"), for: .normal)
        btnEye.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        btnEye.frame = CGRect(x: CGFloat(txtPassword.frame.size.width - 22), y: CGFloat(5), width: CGFloat(15), height: CGFloat(15))
        btnEye.addTarget(self, action: #selector(self.btnShowPasswordInPWD), for: .touchUpInside)
        txtPassword.rightView = btnEye
        txtPassword.rightViewMode = .always
    }
    
    //MARK: Button to visable password Or Hide Password
    @objc func btnShowPasswordInPWD() -> Void
    {
        if isShowPassword == false{
            self.txtPassword.isSecureTextEntry = false
            isShowPassword = true
            self.btnEye.setImage(UIImage(named: "eye"), for: .normal)//eyeopen
            
        }else{
            self.btnEye.setImage(UIImage(named: "eye"), for: .normal)//eyeclose
            self.txtPassword.isSecureTextEntry = true
            isShowPassword = false
        }
    }
  
    
    private func setupTextView() -> Void {
        let str = "Dont have account yet? "
        let attributedString = NSMutableAttributedString(string: str)
        var foundRange = attributedString.mutableString.range(of: "Signup")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Theme.textYellowColor, range: foundRange)

        
        
        
        let simpleText = NSMutableAttributedString(string: "Dont have account yet? ")
                simpleText.addAttribute(NSAttributedString.Key.font,
                                        value: UIFont.appFont_Bold(Size: 14.0),
                                  range: NSRange(location: 0, length: simpleText.length))
        simpleText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: simpleText.length))
                
                let termsOfService = NSMutableAttributedString(string: "Signup!")
                termsOfService.addAttribute(NSAttributedString.Key.font,
                                            value: UIFont.appFont_Bold(Size:14.0),
                                              range: NSRange(location: 0, length: termsOfService.length))
        termsOfService.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.Theme.textYellowColor, range: NSRange(location: 0, length: termsOfService.length))
                simpleText.append(termsOfService)
        
        self.txtViewSignupButton.attributedText = simpleText
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(btnSignupPush))
        self.txtViewSignupButton.isUserInteractionEnabled = true
        self.txtViewSignupButton.addGestureRecognizer(tapGesture)
    }
    
    
    
    //MARK: Buttons Action
    
    @objc func btnSignupPush(){
        
           if let objSignupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController{
               self.navigationController?.pushViewController(objSignupVC, animated: true )
           }
        
    
//        #warning("Redirect To Home Screen Code")
        
//        if let objTabbar = self.storyboard?.instantiateViewController(withIdentifier: "TSTabBarControllerViewController") as? TSTabBarControllerViewController{
//            appDelegate.window?.rootViewController = objTabbar
//        }
         
    }
    
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
//#warning("Temp Skip Login")

//        self.loginSuccess()

        
        
//        if txtUsername.text?.isValidEmail() == true{
            self.loginFirebaseAuthMethod(email: self.txtUsername.text ?? "", password: self.txtPassword.text ?? "") { [unowned self] result in
                switch result {
                    case .success:
                    
                    print(result)
    //                TSUser.shared.isLogin = true
//                    TSUser.shared.saveUserDetails()
                    
                        self.loginSuccess()
                    case .failure(let error):
                        self.didFailToLogin(withError: error)
                }
            }

//        }else{
//            retrieveUserEmail(userName: txtUsername.text ?? "") { userEmail in
//                self.loginFirebaseAuthMethod(email: self.txtUsername.text ?? "", password: self.txtPassword.text ?? "") { [unowned self] result in
//                    switch result {
//                        case .success:
//        //                TSUser.shared.isLogin = true
//        //                TSUser.shared.saveUserDetails()
//
//                            self.loginSuccess()
//                        case .failure(let error):
//                            self.didFailToLogin(withError: error)
//                    }
//                }
//
//            }
//        }
        
    }
    
    
    
//    func retrieveUserEmail(userName : String, completionBlock : ((_ userEmail : String) -> Void)){
//
//        var userEmail : String!
//
//        let ref = Database.database().reference(fromURL: "https://toonstreetbackend-default-rtdb.firebaseio.com/")
//
//        _ = ref.child("users").child("\(userName)").observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value(forKey: "email"))
//            userEmail = snapshot.value(forKey: "email") as? String
//            completionBlock(userEmail)
//
//        })
////       print(userEmail)
//
//    }
    
    
    //MARK:Firebase Login Method
    
    func loginFirebaseAuthMethod(email: String, password: String, completion: @escaping ((Result<Bool, Error>) -> Void)) {
                do{
                    var emailStr = email
                    let passwordStr = try self.validatePassword(password)
                    TSLoader.shared.showLoader()

                    if emailStr.isValidEmail() == false{
                        let ref = Database.database().reference(fromURL: FirebaseBaseURL)

                        _ = ref.child(APIKey.users).child("\(emailStr)").observeSingleEvent(of: .value, with: { (snapshot) in


                            guard let value = snapshot.value else { return }

                            
                            if let dictValue = value as? NSDictionary{
                                
                                
                                emailStr = dictValue.value(forKey: "email") as? String ?? ""//snapshot.value(forKey: "email") as? String ?? ""

                            
                            Auth.auth().signIn(withEmail: emailStr, password: passwordStr) { [weak self] authResult, error in
                //              guard let strongSelf = self else { return }
                                if error != nil{
                                    TSLoader.shared.hideLoader()
                                    completion(.failure(error!))
        //                            TSLoader.shared.hideLoader()
                                    UIAlertController.alert(message: error!.localizedDescription)
                                }else{

                                    TSUser.shared.uID = authResult?.user.uid ?? ""
                                    TSUser.shared.email = authResult?.user.email ?? ""
                                    TSUser.shared.saveUserDetails()

//                                    print(authResult);
                                    TSLoader.shared.hideLoader()
                                    UserDefaults.standard.set(true, forKey: "isLogin") //Bool
                                    UserDefaults.standard.synchronize()
                                    completion(.success(true))

                                }
                            }
                            }
                        })
//                    }
                    }else{
                        
                        Auth.auth().signIn(withEmail: emailStr, password: passwordStr) { [weak self] authResult, error in
            //              guard let strongSelf = self else { return }
                            if error != nil{
                                TSLoader.shared.hideLoader()
                                completion(.failure(error!))
    //                            TSLoader.shared.hideLoader()
                                UIAlertController.alert(message: error!.localizedDescription)
                            }else{

//                                print(authResult?.user.uid);
                                TSUser.shared.uID = authResult?.user.uid ?? ""
                                TSUser.shared.email = authResult?.user.email ?? ""

                                TSLoader.shared.hideLoader()
                                TSUser.shared.saveUserDetails()
                                UserDefaults.standard.set(true, forKey: "isLogin") //Bool
                                UserDefaults.standard.synchronize()
                                completion(.success(true))

                            }
                        }
                        
                        
                    }
                    
                    
        
//                    Auth.auth().sign { result, error in
//                        print(result)
//                    }
                   
        
                }catch {
                    TSLoader.shared.hideLoader()
                    UIAlertController.alert(message: error.localizedDescription)
                    completion(.failure(error))
                }
    
            }
    
    

  

    //MARK: Validation
//    func validatePassword(_ password:String?) throws -> String {
//        guard let password = password else {throw ValidationError.enterPassword}
//        guard password != "" else {throw ValidationError.enterPassword}
//        guard password.count >= 6 else {throw ValidationError.passwordTooShort}
//
//        return password
//    }

   
//    func isEmptyCheckEmail(_ text:String?) throws -> String  {
//
//            guard let textField = text else {throw ValidationError.enterEmail}
//            guard textField != ""  else {throw ValidationError.enterEmail}
//
//            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//            let isValidEmail = emailTest.evaluate(with: text)
//            if isValidEmail == false{
//                throw ValidationError.enterValidEmail
//            }
//            return textField
//
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Login Success
    func loginSuccess() {
        
        print("Login Success")
        
        UserDefaults.standard.set(true, forKey: "isLogin") //Bool
        UserDefaults.standard.synchronize()
        
        
        if let objTabbar = self.storyboard?.instantiateViewController(withIdentifier: "TSTabBarControllerViewController") as? TSTabBarControllerViewController{
            appDelegate.window?.rootViewController = objTabbar
            //self.navigationController?.pushViewController(objSignupVC, animated: true )
        }
        
        
//        let tabBar:TabBarController = UIStoryboard(storyboard: .Main).instantiateViewController()
//        self.navigationController?.pushViewController(tabBar, animated: true)
    }

    //Handle Error
    func didFailToLogin(withError error: Error) {
        print(error)
    }
    
    
    

}
