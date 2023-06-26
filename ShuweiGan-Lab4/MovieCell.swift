//
//  MovieCell.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/29.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell{
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var starView: UIView!
    
    
    let fullStar = UIImage(systemName:"star.fill")
    let halfStar = UIImage(systemName: "star.leadinghalf.fill")
    let Star = UIImage(systemName: "star")
    
    
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
    
}
