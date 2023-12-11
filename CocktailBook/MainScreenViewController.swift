import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cocktailBookModelArr = [CocktailBookModel]()

    @IBOutlet weak var tblObj: UITableView!
    
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
                }            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.cocktailBookModelArr.count > 0) {
            return self.cocktailBookModelArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailBookCell", for: indexPath) as! CocktailBookCell
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        if (self.cocktailBookModelArr.count > 0) {
            let cocktailBookModel = self.cocktailBookModelArr[indexPath.row]
            
            cell.lblTitle.text = cocktailBookModel.name ?? ""
            cell.lblDescription.text = cocktailBookModel.shortDescription ?? ""
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
