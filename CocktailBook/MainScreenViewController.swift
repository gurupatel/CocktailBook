import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
    //Static string
    let allStr = "All Cocktails"
    let alcoholicCocktailsStr = "Alcoholic Cocktails"
    let nonAlcoholicCocktailsStr = "Non-Alcoholic Cocktails"
    let alcoholicStr = "alcoholic"
    let nonAlcoholicStr = "non-alcoholic"

    var filterIndex = 0
    
    var cocktailBookModelArr = [CocktailBookModel]()

    @IBOutlet weak var tblObj: UITableView!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!

    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblObj.delegate = self
        self.tblObj.dataSource = self
        
        //Fetch data from sample.json file
        self.fetchData()
        
        //Added notification for updating the favourite value
        self.addNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.allStr
    }
    
    // MARK: Data Fetching

    func fetchData() {
        //Parsing the JSON file sample.json from bundle
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                do {
                    //Creating the CocktailBookModel object
                    self.cocktailBookModelArr = try JSONDecoder().decode([CocktailBookModel].self, from: data)
                                        
                    //Reload TableView if data is available
                    if (self.cocktailBookModelArr.count > 0) {
                        DispatchQueue.main.async {
                            self.tblObj.reloadData()
                        }
                    }
                } catch let error as NSError {
                    debugPrint(String(describing: error))
                }
            }
        }
    }
    
    // MARK: Notification Actions

    func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.dataChanged(_:)), name: Notification.Name("dataChanged"), object: nil)
    }
    
    @objc func dataChanged(_ notification: NSNotification?) {
        
        //Updating the favourite value according ot the user interaction
        let cocktailBookArr = self.getFilteredArray()
        
        let filterCocktailBookModelArr = cocktailBookArr.filter { $0.id! == notification?.userInfo!["id"] as? String ?? "" }
        if (filterCocktailBookModelArr.count > 0) {
            let cocktailBookModel = filterCocktailBookModelArr[0]
            cocktailBookModel.favourite = Bool(notification?.userInfo!["favourite"] as! String)

            if let row = self.cocktailBookModelArr.firstIndex(where: {$0.id == notification?.userInfo!["id"] as? String ?? ""}) {
                self.cocktailBookModelArr[row] = cocktailBookModel
            }
        }
        
        self.tblObj.reloadData()
        
        //Removing Observer
        NotificationCenter.default.removeObserver(self)
        
        //After removing Observer adding it freshly for new use
        self.addNotificationCenter()
    }

    // MARK: Button Actions

    @IBAction func segmentControllClick(_ sender: Any) {
        //Segment / Filter / Nav Bar Title values are changing here
        switch segmentControlOutlet.selectedSegmentIndex {
        case 0:
            self.title = self.allStr
            self.filterIndex = 0
            
        case 1 :
            self.title = self.alcoholicCocktailsStr
            self.filterIndex = 1

        case 2:
            self.title = self.nonAlcoholicCocktailsStr
            self.filterIndex = 2

        default:
            break
        }
        
        //Refershing data accordingly
        self.tblObj.reloadData()
    }
    
    // MARK: Get Filtered Model Array

    func getFilteredArray() -> [CocktailBookModel] {
        //Display the favorite cocktails at the beginning in the list (pinned) respecting the filter state
        self.cocktailBookModelArr = self.cocktailBookModelArr.sorted { $0.name!.lowercased() < $1.name!.lowercased() }

        //Display a list of the cocktails in an alphabetical order
        self.cocktailBookModelArr = self.cocktailBookModelArr.sorted { $0.favourite ?? false && !($1.favourite ?? false) }

        var cocktailBookListArr = self.cocktailBookModelArr
        
        if (self.filterIndex == 1) {
            cocktailBookListArr = self.cocktailBookModelArr.filter { $0.type! == self.alcoholicStr }
        }
        else if (self.filterIndex == 2) {
            cocktailBookListArr = self.cocktailBookModelArr.filter { $0.type! == self.nonAlcoholicStr }
        }
        //Returing data according to top filter selected
        return cocktailBookListArr
    }
    
    // MARK: UIUITableViewViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getFilteredArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailBookCell", for: indexPath) as! CocktailBookCell
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        //Getting row wise data from object
        let cocktailBookModel = self.getFilteredArray()[indexPath.row]
        
        cell.lblTitle.text = cocktailBookModel.name ?? ""
        cell.lblTitle.textColor = .black
        cell.lblDescription.text = cocktailBookModel.shortDescription ?? ""
        cell.favouriteImg.isHidden = true
        
        if (cocktailBookModel.favourite != nil && cocktailBookModel.favourite! == true) {
            cell.favouriteImg.isHidden = false
            cell.lblTitle.textColor = .purple
        }
        
        return cell
    }
    
    // MARK: UIUITableViewViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                        
        let cocktailBookModel = self.getFilteredArray()[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainScreenStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailMainView") as? DetailMainViewController
        vc?.title = self.title
        vc?.cocktailBookModel = cocktailBookModel
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
