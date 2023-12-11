import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alcoholicStr = "alcoholic"
    let nonAlcoholicStr = "non-alcoholic"

    var filterIndex = 0
    
    var cocktailBookModelArr = [CocktailBookModel]()

    @IBOutlet weak var tblObj: UITableView!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!

    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "All Cocktails"
        
        self.tblObj.delegate = self
        self.tblObj.dataSource = self
        
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
    
    @IBAction func segmentControllClick(_ sender: Any) {
        switch segmentControlOutlet.selectedSegmentIndex {
        case 0:
            self.title = "All Cocktails"
            self.filterIndex = 0
            
        case 1 :
            self.title = "Alcoholic"
            self.filterIndex = 1

        case 2:
            self.title = "Non-Alcoholic"
            self.filterIndex = 2

        default:
            break
        }
        
        self.tblObj.reloadData()
    }
    
    func getFilteredArray() -> [CocktailBookModel] {
        var cocktailBookListArr = self.cocktailBookModelArr
        
        if (self.filterIndex == 1) {
            cocktailBookListArr = self.cocktailBookModelArr.filter { $0.type! == self.alcoholicStr }
        }
        else if (self.filterIndex == 2) {
            cocktailBookListArr = self.cocktailBookModelArr.filter { $0.type! == self.nonAlcoholicStr }
        }
        return cocktailBookListArr
    }
    
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
        cell.lblDescription.text = cocktailBookModel.shortDescription ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cocktailBookModel = self.getFilteredArray()[indexPath.row]
    }
}
