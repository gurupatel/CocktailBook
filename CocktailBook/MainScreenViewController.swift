import UIKit

class MainScreenViewController: UIViewController {
    
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        let json: AnyObject? = jsonString.parseJSONString
                        debugPrint("Response : ", json as Any)
                    }
                }
            }
        }
    }
}

extension String {
        var parseJSONString: AnyObject?
        {
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

            if let jsonData = data
            {
                // Will return an object or nil if JSON decoding fails
                do
                {
                    let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                    if let jsonResult = message as? NSMutableArray
                    {
                        debugPrint(jsonResult)

                        return jsonResult //Will return the json array output
                    }
                    else
                    {
                        return nil
                    }
                }
                catch let error as NSError
                {
                    debugPrint("An error occurred: \(error)")
                    return nil
                }
            }
            else
            {
                // Lossless conversion of the string was not possible
                return nil
            }
        }
}
