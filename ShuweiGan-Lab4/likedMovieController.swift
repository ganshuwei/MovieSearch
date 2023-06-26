//
//  likedMovieController.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/31.
//

import UIKit

class likedMovieController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var Movietitle: UILabel!
    @IBOutlet weak var movieInfo: UILabel!
    @IBOutlet weak var movieDp: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    var rateMovie:String?
    var info:String?
    var titleForMovie: String?
    var dP:String?
    var imageOfMovie:UIImage?
    let fullStar = UIImage(systemName:"star.fill")
    let halfStar = UIImage(systemName: "star.leadinghalf.fill")
    let Star = UIImage(systemName: "star")
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if info != nil{
            self.movieInfo.text = info!
        }
        if titleForMovie != nil{
            self.Movietitle.text = titleForMovie!
        }
        if rateMovie != nil{
            let rateValue = Double(rateMovie!)!
            displayRateStar(rateValue)
            self.rate.text = String(round(rateValue*10)/10.0)
        }
        if imageOfMovie != nil{
            self.movieImage.image = imageOfMovie!
            self.bgImage.image = imageOfMovie!
        }
        if dP != nil{
            self.movieDp.text = dP!
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareMovie(_ sender: Any) {
        let downloadImage = self.view.asImage()
        let imageServer = ImageSaver()
        imageServer.writeToPhotoAlbum(image: downloadImage)
        showScreenshotEffect()
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
    
    //flash effect
    //reference:https://stackoverflow.com/questions/42230676/how-to-obtain-a-screen-flash-effect-like-screen-capture-effect
    func showScreenshotEffect() {
        let snapshotView = UIView()
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snapshotView)
        // Activate full screen constraints
        let constraints:[NSLayoutConstraint] = [
            snapshotView.topAnchor.constraint(equalTo: view.topAnchor),
            snapshotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            snapshotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            snapshotView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        // White because it's the brightest color
        snapshotView.backgroundColor = UIColor.white
        // Animate the alpha to 0 to simulate flash
        UIView.animate(withDuration: 0.2, animations: {
            snapshotView.alpha = 0
        }) { _ in
            // Once animation completed, remove it from view.
            snapshotView.removeFromSuperview()
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
