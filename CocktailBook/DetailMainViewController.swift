//
//  DetailMainViewController.swift
//  CocktailBook
//
//  Created by Gaurang Patel on 11/12/23.
//

import UIKit

class DetailMainViewController: UIViewController {
    
    var cocktailBookModel = CocktailBookModel()
    
    @IBOutlet weak var scrollViewObj: UIScrollView!
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPreparationMinutes: UILabel!
    @IBOutlet weak var lblLongDescription: UILabel!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!

    @IBOutlet weak var imgHgtConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Removing back title
        self.navigationController?.navigationBar.topItem?.title = " "
    }

    func createViewData() {

        //Showing data from the CocktailBookModel
        self.lblTitle.text = self.cocktailBookModel.name ?? ""
        self.lblPreparationMinutes.text = String(format: "%d mins", self.cocktailBookModel.preparationMinutes ?? 0)
        self.lblLongDescription.text = self.cocktailBookModel.longDescription ?? ""
        
        self.cocktailImage.image = UIImage(named: self.cocktailBookModel.imageName ?? "")
        
        //Calculating & setting up dynamic height of image run time
        let ratio = self.cocktailImage.image!.size.width / self.cocktailImage.image!.size.height
        let newHeight = self.cocktailImage.frame.width / ratio
        self.imgHgtConstraint.constant = newHeight
        self.view.layoutIfNeeded()
        
        if (self.cocktailBookModel.favourite != nil && self.cocktailBookModel.favourite! == true) {
            self.favouriteBtn.isSelected = true
        }
    }
    
    @IBAction func favouriteBtnPressed(sender : UIButton) {
        sender.backgroundColor = .clear

        var searchDataDict:[String: String] = ["favourite": "false", "id": self.cocktailBookModel.id ?? ""]
        
        if sender.isSelected {
            // set deselected
            sender.isSelected = false
            
            searchDataDict = ["favourite": "false", "id": self.cocktailBookModel.id ?? ""]
        } else {
            // set selected
            sender.isSelected = true
            
            searchDataDict = ["favourite": "true", "id": self.cocktailBookModel.id ?? ""]
        }
        
        NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil, userInfo: searchDataDict)
    }
}
