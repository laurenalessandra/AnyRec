//
//  ViewController.swift
//  AnyRec
//
//  Created by Lauren Simon on 28.12.19.
//  Copyright © 2019 Lauren Simon. All rights reserved.
//

import UIKit
import FirebaseUI
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var authUI: FUIAuth!
    var index: Int!
    var dataLoader: FirestoreDataLoader!
    var googlePhotoLoader = GooglePhotoLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        greetingLabel.text = GreetingSimulator.determineGreeting()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        signIn()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            view.isHidden = true
            dataLoader.firestoreData = []
            signIn()
        } catch {
            view.isHidden = true
        }
    }
    
    func reloadData() {
        dataLoader = FirestoreDataLoader()
        dataLoader.loadData(dataType: .cities) {
            self.collectionView.reloadData()
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
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCity" {
            let destination = segue.destination as! CityViewController
            destination.city = dataLoader.firestoreData[index] as? City
        }
    }
    
    @IBAction func unwindFromCityViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! CityViewController
        let dataUpdater = FirestoreDataUpdater(documentID: source.city.documentID)
        dataUpdater.deleteData() { success in
            if success {
                self.reloadData()
                print("Delete successful!")
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
            reloadData()
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
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataLoader.firestoreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
        let city = dataLoader.firestoreData[indexPath.row] as! City
        
        cityCell.cityImage.image = UIImage(named: "empty-card")
        if let imageFromCache = googlePhotoLoader.imageCache.object(forKey: city.placeID as AnyObject) as? UIImage {
            cityCell.cityImage.image = imageFromCache
        } else {
            googlePhotoLoader.loadFirstPhotoForPlace(placeID: city.placeID, imageView: cityCell.cityImage)
        }
        
        cityCell.updateName(city)
        cityCell.layer.cornerRadius = 10
        return cityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        index = indexPath.row
        return true
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        let city = City(name: place.name ?? "", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, placeID: place.placeID ?? "", postingUserID: "", documentID: "")
        
        let dataUpdater = FirestoreDataUpdater(documentID: city.documentID)
        dataUpdater.saveData(data: city) {
            success in
            if success {
                self.reloadData()
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
