//
//  ViewController.swift
//  HelloWorld
//
//  Created by Magiczne on 27/11/2020.
//

import Alamofire
import ObjectMapper
import SwiftyJSON
import UIKit

class CardCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var cards: [Card] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewOutlet.delegate = self
        self.tableViewOutlet.dataSource = self
    }


    @IBAction func onSearch(_ sender: Any) {
        AF.request(self.getUrl(query: self.textFieldOutlet.text!)).responseString { response in
            switch (response.result) {
            
            case .success(_):
                do {
                    let result = try Mapper<CardsResponse>().map(JSONString: response.result.get())
                    
                    self.cards = result!.cards
                    self.tableViewOutlet.reloadData()
                    print(self.cards[0])
                } catch {
                    self.showApiCallError()
                    print("Parsing failure")
                }
                break
                
            case .failure(_):
                self.showApiCallError()
                print("API failure")
                break
            }
        }
    }
    
    private func getUrl(query: String) -> String {
        let url = "https://api.pokemontcg.io/v1/cards?name=\(query)"
        
        print("Making call to \(url)")
        return url
    }
    
    private func showApiCallError() {
        let alert = UIAlertController(title: "Error", message: "API call failed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        let card = self.cards[indexPath.row]
        
        cell.img.downloaded(from: card.imageUrl)
        cell.label.text = card.name
        
        return cell
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
