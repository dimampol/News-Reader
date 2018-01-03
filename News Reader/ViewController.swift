//
//  ViewController.swift
//  News Reader
//
//  Created by apple on 2018-01-02.
//  Copyright © 2018 Dmitrii Poliakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!
    
    
    var showMenu = false
    let sourcesArray = ["bbc-news", "business-insider", "cbs-news", "cnbc", "financial-post", "independent", "le-monde", "nhl-news", "talksport", "the-economist", "wired"]
    var articlesArray: [Article]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 5
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchArticles(fromSource: "cbs-news")
        navigationItem.title = "CBS News"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! WebviewViewController
        destVC.article = sender as? Article
    }
    
    func fetchArticles(fromSource provider: String){
        
        let urlString = "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=9bf7037b729d4ddebed6b23692b31f2a"
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil{
                return
            }
            
            self.articlesArray = [Article]()
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                
                if let articles = json["articles"] as? [[String: Any]]{
                    for article in articles{
                        let articleForArray = Article()
                        if let title = article["title"] as? String, let author = article["author"] as? String, let description = article["description"] as? String, let articleURL = article["url"] as? String, let imageURL = article["urlToImage"] as? String{
                            
                            articleForArray.articleTitle = title
                            articleForArray.author = author
                            articleForArray.articleDescription = description
                            articleForArray.articleURL = articleURL
                            articleForArray.imageURL = imageURL
                        }
                        self.articlesArray?.append(articleForArray)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            catch let error{
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articlesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articlesArray?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        cell.articleTitleLabel.text = article?.articleTitle
        cell.articleDescriptionLabel.text = article?.articleDescription
        cell.authorLabel.text = article?.author
        cell.articleImage.downloadImage(from: (article?.imageURL)!)//
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleURL = articlesArray![indexPath.row]
        performSegue(withIdentifier: "MasterToWeb", sender: articleURL)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Sliding menu
    
    func closeMenu(){
        
        leadingConstraint.constant = -150
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        
        if !showMenu{
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else{
            closeMenu()
        }
        
        showMenu = !showMenu
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        
        for button in menuButtons{
            sender.isSelected = true
            if button.isSelected{
                button.isSelected = false
            }
        }
        
        navigationItem.title = sender.title(for: .normal)
        
        fetchArticles(fromSource: sourcesArray[sender.tag])
        closeMenu()
        showMenu = !showMenu
        
    }
    
}


