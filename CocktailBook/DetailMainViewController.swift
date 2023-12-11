//
//  DetailMainViewController.swift
//  CocktailBook
//
//  Created by Gaurang Patel on 11/12/23.
//

import UIKit

class DetailMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var totalHgt = 0.0
    var cocktailBookModel = CocktailBookModel()
    
    @IBOutlet weak var scrollViewObj: UIScrollView!
    @IBOutlet weak var tblObj: UITableView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPreparationMinutes: UILabel!
    @IBOutlet weak var lblLongDescription: UILabel!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!

    @IBOutlet weak var imgHgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblHgtConstraint: NSLayoutConstraint!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblObj.delegate = self
        self.tblObj.dataSource = self

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
        self.lblTitle.textColor = .black
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
            self.lblTitle.textColor = .purple
        }
    }
    
    // MARK: Button Actions

    @IBAction func favouriteBtnPressed(sender : UIButton) {
        sender.backgroundColor = .clear

        var searchDataDict:[String: String] = ["favourite": "false", "id": self.cocktailBookModel.id ?? ""]
        
        if sender.isSelected {
            // set deselected
            sender.isSelected = false
            self.lblTitle.textColor = .black

            searchDataDict = ["favourite": "false", "id": self.cocktailBookModel.id ?? ""]
        } else {
            // set selected
            sender.isSelected = true
            self.lblTitle.textColor = .purple

            searchDataDict = ["favourite": "true", "id": self.cocktailBookModel.id ?? ""]
        }
        
        NotificationCenter.default.post(name: Notification.Name("dataChanged"), object: nil, userInfo: searchDataDict)
    }
    
    // MARK: UIUITableViewViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cocktailBookModel.ingredients != nil && self.cocktailBookModel.ingredients!.count > 0) {
            return self.cocktailBookModel.ingredients!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell", for: indexPath) as! IngredientsCell
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        //Getting row wise data from object
        cell.lblTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cell.lblTitle.text = self.cocktailBookModel.ingredients![indexPath.row]
        cell.lblTitle.textAlignment = .left
        cell.lblTitle.numberOfLines = 0
        cell.lblTitle.sizeToFit()
        
        self.totalHgt = (self.totalHgt + cell.lblTitle.frame.size.height)
        
        if ((self.cocktailBookModel.ingredients!.count - 1) == indexPath.row) {
            self.tblHgtConstraint.constant = self.totalHgt + 60 //(Padding)
        }

        return cell
    }
    
    // MARK: UIUITableViewViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
