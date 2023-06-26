//
//  FavoritesView.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/30.
//

import UIKit

class FavoritesView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var movieTitle:[String] = []
    var movieId:[String] = []
    var movieRate:[String] = []
    var movieInfo:[String] = []
    var idDict:[String:Int] = [:]
    var imageData:[Data] = []
    var movieDp:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableCell")
        cell.textLabel!.text = movieTitle[indexPath.row]
        cell.imageView?.image = UIImage(data:imageData[indexPath.row])
        return cell
    }
    
    func removeAll(){
        movieTitle  = []
        movieId = []
        movieRate   = []
        movieInfo   = []
        idDict   =  [:]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.movieDp.remove(at: indexPath.row)
            UserDefaults.standard.set(movieDp,forKey: "dpkey")
            self.imageData.remove(at: indexPath.row)
            UserDefaults.standard.set(imageData,forKey: "imagekey")
            self.movieTitle.remove(at: indexPath.row)
            UserDefaults.standard.set(movieTitle,forKey: "titlekey")
            self.idDict.removeValue(forKey:movieId[indexPath.row])
            UserDefaults.standard.set(idDict,forKey: "idDict")
            self.movieId.remove(at:indexPath.row)
            UserDefaults.standard.set(movieId,forKey: "idkey")
            self.movieInfo.remove(at:indexPath.row)
            UserDefaults.standard.set(movieInfo,forKey: "infokey")
            self.movieRate.remove(at:indexPath.row)
            UserDefaults.standard.set(movieRate,forKey: "ratekey")
            self.tableView.deleteRows(at: [indexPath], with:.automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"localPage") as! likedMovieController
        vc.info = movieInfo[indexPath.row]
        vc.rateMovie = movieRate[indexPath.row]
        vc.titleForMovie = movieTitle[indexPath.row]
        vc.imageOfMovie = UIImage(data:imageData[indexPath.row])
        vc.dP = movieDp[indexPath.row]
        present(vc, animated: true)
    }
    
    func setUpArray(){
        movieTitle = (UserDefaults.standard.array(forKey: "titlekey") ?? []) as! [String]
        idDict = UserDefaults.standard.dictionary(forKey: "idDict") as? [String:Int] ?? [:]
        movieInfo = (UserDefaults.standard.array(forKey: "infokey") ?? []) as! [String]
        movieRate = (UserDefaults.standard.array(forKey: "ratekey") ?? []) as! [String]
        movieId = (UserDefaults.standard.array(forKey: "idkey") ?? []) as! [String]
        imageData = (UserDefaults.standard.array(forKey: "imagekey") ?? []) as! [Data]
        movieDp = (UserDefaults.standard.array(forKey: "dpkey") ?? []) as! [String]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initiate()
        setUpArray()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpArray()
        tableView.reloadData()
    }
    
    
    //for test
    func initiate(){
        UserDefaults.standard.set(movieDp,forKey: "dpkey")
        UserDefaults.standard.set(movieDp,forKey: "imagekey")
        UserDefaults.standard.set(movieTitle,forKey: "titlekey")
        UserDefaults.standard.set(idDict,forKey: "idDict")
        UserDefaults.standard.set(movieId,forKey: "idkey")
        UserDefaults.standard.set(movieInfo,forKey: "infokey")
        UserDefaults.standard.set(movieRate,forKey: "ratekey")
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
