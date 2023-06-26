//
//  ViewController.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/29.
//

import UIKit
import Network

class ViewController: UIViewController,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var keyWordLabel: UILabel!
    
    let UrlPrefix = "https://api.themoviedb.org/3/"
    let apiKey = "api_key=5993ca77a03de7957bdf6ee8d713f7dc"
    let UrlSuffix = "&page=1"
    var theData:[Movie]=[]
    var theImageCache:[UIImage]=[]
    var popularMovies:[Movie]=[]
    var popularImageCache:[UIImage]=[]
    let imageUrlPrefix = "https://image.tmdb.org/t/p/w500/"
    let defaultImage:UIImage = UIImage(named: "default")!
    var idDict:[String:Int] = [:]
    let spinnerView = UIActivityIndicatorView(style: .large)
    let defaultKeyword = "What's Popular"
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCell
        let keyExists = (idDict[String(theData[indexPath.row].id)] != nil)
        if keyExists{
            cell.starView.isHidden = false
        }else{
            cell.starView.isHidden = true
        }
        cell.movieImage.image = theImageCache[indexPath.row]
        cell.movieTitle.text = theData[indexPath.row].title
        cell.movieRate.text = String(theData[indexPath.row].vote_average)
        cell.displayRateStar(theData[indexPath.row].vote_average)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovie", sender: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let keyExists = (idDict[String(theData[indexPath.row].id)] != nil)
        if keyExists{
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                let open = UIAction(title: "In your Favorites", image: UIImage(systemName: "star.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .disabled, state: .off){ _ in
                }
                return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [open])})
            return config
        }else{
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                let open = UIAction(title: "Favorite", image: UIImage(systemName: "star"), identifier: nil, discoverabilityTitle: nil, state: .off){ _ in
                    self.addToFavorites(movie: self.theData[indexPath.row], image: self.theImageCache[indexPath.row])
                    self.collectionView.reloadData()
                    
                }
                return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [open])
            })
            return config
        }
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailedVC = segue.destination as? DetailedViewController
        detailedVC?.displayedMovie = self.theData[sender as! Int]
        detailedVC?.movieImage = self.theImageCache[sender as! Int]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        idDict = UserDefaults.standard.dictionary(forKey: "idDict") as? [String:Int] ?? [:]
        searchBar.delegate=self
        collectionView.dataSource=self
        collectionView.delegate=self
        self.searchPopularMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        idDict = UserDefaults.standard.dictionary(forKey: "idDict") as? [String:Int] ?? [:]
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let unwrapped = searchBar.text {
            if !unwrapped.trimmingCharacters(in: .whitespaces).isEmpty {
                keyWordLabel.text = "Results of " + unwrapped
                searchMovie(unwrapped)
            }else{
                keyWordLabel.text = defaultKeyword
                theData = popularMovies
                theImageCache = popularImageCache
                self.collectionView.reloadData()
            }
        }
                
    }
    
    func searchMovie(_ keyWord:String){
        theData.removeAll()
        theImageCache.removeAll()
        self.view.addSubview(spinnerView)
        spinnerView.center = self.view.center
        spinnerView.startAnimating()
        let keywordStr = keyWord.replacingOccurrences(of: " ", with: "%20")
        let searchUrl = UrlPrefix+"search/movie?"+apiKey+"&query="+keywordStr+UrlSuffix
        DispatchQueue.global(qos: .userInitiated).async {
            self.theData = self.fetchDataForCollectionView(searchUrl)
            self.cacheImages()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.spinnerView.stopAnimating()
            }
        }
    }
    
    func searchPopularMovies(){
        self.view.addSubview(spinnerView)
        spinnerView.center = self.view.center
        spinnerView.startAnimating()
        let searchUrl = "https://api.themoviedb.org/3/movie/popular?api_key=5993ca77a03de7957bdf6ee8d713f7dc&language=en-US&page=1"
        DispatchQueue.global(qos: .userInitiated).async {
            self.popularMovies = self.fetchDataForCollectionView(searchUrl)
            self.cachePopularImage()
            DispatchQueue.main.async {
                self.theData = self.popularMovies
                self.theImageCache = self.popularImageCache
                self.collectionView.reloadData()
                self.spinnerView.stopAnimating()
            }
        }
    }
    
    func fetchDataForCollectionView(_ path: String) -> [Movie]{
        let url = URL(string:path)
        let data = try!Data(contentsOf:url!)
        let APIResult = try! JSONDecoder().decode(APIResults.self, from: data)
        return APIResult.results
    }
    
    
    func cacheImages() {
        for movie in theData {
            if let unwrapped = movie.poster_path{
                if unwrapped == "" {
                    theImageCache.append(defaultImage)
                }
                let url = URL(string: imageUrlPrefix + unwrapped)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                theImageCache.append(image!)
            }else{
                theImageCache.append(defaultImage)
            }
            
        }
        
    }
    
    func cachePopularImage(){
        for movie in popularMovies {
            if let unwrapped = movie.poster_path{
                if unwrapped == "" {
                    popularImageCache.append(defaultImage)
                }
                let url = URL(string: imageUrlPrefix + unwrapped)
                let data = try? Data(contentsOf: url!)
                let image = UIImage(data: data!)
                popularImageCache.append(image!)
            }else{
                popularImageCache.append(defaultImage)
            }
            
        }
    }
    
    func addToUserdefault(addedElement:String,key:String){
        let storeArray = UserDefaults.standard.array(forKey: key) as? [String]
        var element = [addedElement]
        if storeArray != nil{
            element = storeArray! + element
        }
        UserDefaults.standard.set(element, forKey: key)
    }
    
    func addToFavorites(movie:Movie,image:UIImage){
        idDict[String(movie.id)]=idDict.count
        UserDefaults.standard.set(idDict,forKey: "idDict")
        addToUserdefault(addedElement: String(movie.id), key: "idkey")
        addToUserdefault(addedElement: movie.title, key: "titlekey")
        addToUserdefault(addedElement: String(round(movie.vote_average*10)/10.0), key: "ratekey")
        let infoText = movie.release_date ?? "" + "(" + movie.original_language + ")"
        addToUserdefault(addedElement: infoText, key: "infokey")
        addToUserdefault(addedElement: movie.overview, key: "dpkey")
        let data = image.pngData()
        var imageArray = (UserDefaults.standard.array(forKey: "imagekey") ?? []) as! [Data]
        imageArray.append(data!)
        UserDefaults.standard.set(imageArray, forKey: "imagekey")
    }

    


}

