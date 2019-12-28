//
//  ViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greetingLabel.text = GreetingSimulator.determineGreeting()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        signIn()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            view.isHidden = true
            signIn()
        } catch {
            view.isHidden = true
        }
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [ FUIGoogleAuth(), ]
        self.authUI.providers = providers
        signOutButton.title = ""
        
        if authUI.auth?.currentUser == nil {
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            signOutButton.title = Auth.auth().currentUser!.isAnonymous ? "Sign In" : "Sign Out"
            view.isHidden = false
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if error != nil {
                print("Sign in failed")
            }
            if authResult != nil {
                self.signOutButton.title = "Sign In"
                self.view.isHidden = false
            }
            
        }
    }
    
}
extension ViewController: FUIAuthDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if authDataResult?.user != nil {
            view.isHidden = false
            signOutButton.title = "Sign Out"
        } else {
            signInAnonymously()
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        let logoFrame = CGRect(x: self.view.frame.origin.x + 16, y: 150, width: self.view.frame.width - (16 * 2), height: 300)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "front-icon")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
    
}

