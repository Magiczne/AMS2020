//
//  ViewController.swift
//  HelloWorld
//
//  Created by Magiczne on 27/11/2020.
//

import Alamofire
import ObjectMapper
import SwiftyJSON


class CardCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
}

class CardTapGestureRecognizer: UITapGestureRecognizer {
    var image: String = ""
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
        
        // Bind data
        cell.img.downloaded(from: card.imageUrl)
        cell.label.text = card.name
        
        // Add onTap handler
        let tapGesture = CardTapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGesture.image = card.imageUrl
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }

    @objc func handleTap(_ sender: CardTapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let cardViewController = storyBoard.instantiateViewController(identifier: "CardView") as! CardViewController
        
        self.present(cardViewController, animated: true, completion: {
            cardViewController.loadImage(image: sender.image)
        })
    }
}
