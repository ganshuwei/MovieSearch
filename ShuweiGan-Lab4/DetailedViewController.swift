//
//  DetailedViewController.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/30.
//

import UIKit
import Network

class DetailedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageVIew: UIImageView!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var RMcollectionView: UICollectionView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var insLabel: UILabel!
    
    
    
    var displayedMovie:Movie!
    var movieImage:UIImage?
    var recommendatedMovies:[Movie]=[]
    var RMImageCache:[UIImage]=[]
    var ifLiked:Bool!
    //rate star image
    var idDict:[String:Int] = [:]
    let fullStar = UIImage(systemName:"star.fill")
    let halfStar = UIImage(systemName: "star.leadinghalf.fill")
    let Star = UIImage(systemName: "star")
    //url
    let UrlPrefix = "https://api.themoviedb.org/3/"
    let apiKey = "api_key=5993ca77a03de7957bdf6ee8d713f7dc"
    let UrlSuffix = "&page=1"
    let imageUrlPrefix = "https://image.tmdb.org/t/p/w500"
    //default image for movie without image from TMDB
    let defaultImage:UIImage = UIImage(named: "default")!
    let spinnerView = UIActivityIndicatorView(style: .large)
    

    


    
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recommendatedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMcell", for: indexPath) as! MovieCell
        let keyExists = (idDict[String(recommendatedMovies[indexPath.row].id)] != nil)
        if keyExists{
            cell.starView.isHidden = false
        }else{
            cell.starView.isHidden = true
        }
        cell.movieImage.image = RMImageCache[indexPath.row]
        cell.movieTitle.text = recommendatedMovies[indexPath.row].title
        //1 Decimal Place
        cell.movieRate.text = String(round(recommendatedMovies[indexPath.row].vote_average*10)/10.0)
        cell.displayRateStar(recommendatedMovies[indexPath.row].vote_average)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = storyboard?.instantiateViewController(withIdentifier: "DetailedView") as! DetailedViewController
        dvc.displayedMovie = recommendatedMovies[indexPath.row]
        dvc.movieImage = RMImageCache[indexPath.row]
        show(dvc, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        idDict = UserDefaults.standard.dictionary(forKey: "idDict") as? [String:Int] ?? [:]
        RMcollectionView.delegate = self
        RMcollectionView.dataSource = self
        spinnerView.color = UIColor.black
        if let unwrapped = displayedMovie{
            let keyExists = (idDict[String(unwrapped.id)] != nil)
            if keyExists{
                ifLiked = true
            }else{
                ifLiked = false
            }
            btnOutletControl()
            movieTitle.text = unwrapped.title
            movieImageVIew.image = movieImage!
            bgImage.image = movieImage!
            movieRate.text = String(unwrapped.vote_average.roundTo(p: 1))
            self.displayRateStar(unwrapped.vote_average)
            overView.text = unwrapped.overview
            if let unwrappedDate = unwrapped.release_date{
                movieInfo.text = unwrappedDate
            }else{
                movieInfo.text = "None"
            }
            movieInfo.text! += ("(" + unwrapped.original_language + ")")
            
        }
        self.searchRMmovie()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        idDict = UserDefaults.standard.dictionary(forKey: "idDict") as? [String:Int] ?? [:]
        let keyExists = (idDict[String(displayedMovie.id)] != nil)
        if keyExists{
            ifLiked = true
        }else{
            ifLiked = false
        }
        btnOutletControl()
        self.RMcollectionView.reloadData()
    }
    
    @IBAction func fBtn(_ sender: Any) {
        if !ifLiked{
            idDict[String(displayedMovie.id)]=idDict.count
            UserDefaults.standard.set(idDict,forKey: "idDict")
            self.appendToFavorites(addedElement: String(displayedMovie.id), key: "idkey")
            self.appendToFavorites(addedElement: movieTitle.text!, key: "titlekey")
            self.appendToFavorites(addedElement: movieRate.text!, key: "ratekey")
            self.appendToFavorites(addedElement: movieInfo.text!, key: "infokey")
            self.appendToFavorites(addedElement: overView.text!, key: "dpkey")
            let data = movieImage!.pngData()
            var imageArray = (UserDefaults.standard.array(forKey: "imagekey") ?? []) as! [Data]
            imageArray.append(data!)
            UserDefaults.standard.set(imageArray, forKey: "imagekey")

            ifLiked = true
        }else{
            self.removeFavorites(addedElement: String(displayedMovie.id), key: "idkey")
            self.removeFavorites(addedElement: movieTitle.text!, key: "titlekey")
            self.removeFavorites(addedElement: movieRate.text!, key: "ratekey")
            self.removeFavorites(addedElement: movieInfo.text!, key: "infokey")
            self.removeFavorites(addedElement: overView.text!, key: "dpkey")
            let index = self.idDict[String(displayedMovie.id)]
            var imageArray = (UserDefaults.standard.array(forKey: "imagekey") ?? []) as! [Data]
            if index != nil{
                imageArray.remove(at: index!)
            }
            UserDefaults.standard.set(imageArray, forKey: "imagekey")
            idDict.removeValue(forKey: String(displayedMovie.id))
            UserDefaults.standard.set(idDict,forKey: "idDict")
            ifLiked = false
        }
        btnOutletControl()

    }
    
    func appendToFavorites(addedElement:String,key:String){
        let storeArray = UserDefaults.standard.array(forKey: key) as? [String]
        var element = [addedElement]
        if storeArray != nil{
            element = storeArray! + element
        }
        UserDefaults.standard.set(element, forKey: key)
    }
    
    func removeFavorites(addedElement:String,key:String){
        var storeArray = (UserDefaults.standard.array(forKey: key) ?? []) as! [String]
        let index = self.idDict[String(displayedMovie.id)]
        if index != nil{
            storeArray.remove(at: index!)
        }
        UserDefaults.standard.set(storeArray, forKey: key)
        
    }
    
    
    func displayRateStar(_ vote: Double){
        var i = 0
        let imageList:[UIImageView]=[star1,star2,star3,star4,star5]
        var starNum = vote / 2
        while starNum >= 0 && i < 5 {
            if (0 <= starNum && starNum < 0.25){
                imageList[i].image = Star
            }else if (starNum >= 0.25 && starNum < 0.75){
                imageList[i].image = halfStar
            }else{
                imageList[i].image = fullStar
            }
            starNum -= 1
            i += 1
        }
        
        if i < imageList.count-1{
            for j in (i..<imageList.count).reversed(){
                imageList[j].image = Star
            }
        }
        
    }
    
    func btnOutletControl(){
        if self.ifLiked{
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            insLabel.text = "In your Favorites"
        }else{
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            insLabel.text = "Add to Favorites"
        }
    }
    
    func searchRMmovie(){
        recommendatedMovies.removeAll()
        RMImageCache.removeAll()
        if (displayedMovie.id) != nil{
            let searchUrl = UrlPrefix + "movie/" + String(displayedMovie!.id) + "/recommendations?" + apiKey + UrlSuffix
            self.view.addSubview(spinnerView)
            spinnerView.center = self.RMcollectionView.center
            spinnerView.startAnimating()
            self.fetchDataForCollectionView(searchUrl)
            self.cacheRMImages()
            self.spinnerView.stopAnimating()
            self.RMcollectionView.reloadData()
            
            }
    }
        
    
    
    private func fetchDataForCollectionView(_ path: String){
        let url = URL(string:path)
        let data = try!Data(contentsOf:url!)
        let APIResult = try! JSONDecoder().decode(APIResults.self, from: data)
        recommendatedMovies = APIResult.results
    }
    
    private func cacheRMImages() {
        for movie in recommendatedMovies {
            if let unwrapped = movie.poster_path{
                if unwrapped == "" {
                    RMImageCache.append(defaultImage)
                }
                let url = URL(string: imageUrlPrefix + unwrapped)
                let data = try? Data(contentsOf: url!)
                if data == nil{
                    RMImageCache.append(defaultImage)
                }else{
                    let image = UIImage(data: data!)
                    RMImageCache.append(image!)
                }

            }else{
                RMImageCache.append(defaultImage)
            }
            
        }
    }
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
