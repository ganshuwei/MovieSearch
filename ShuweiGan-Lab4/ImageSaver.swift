//
//  ImageSaver.swift
//  ShuweiGan_Lab3
//
//  Created by 甘书玮 on 2022/10/6.
//

import Foundation
import UIKit

class ImageSaver:NSObject{
    
    func writeToPhotoAlbum(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image,self, #selector(saveCompleted),nil)
    }
    
    @objc func saveCompleted(_ image:UIImage, didFinishSavingWithError error:Error?,contextInfo:UnsafeRawPointer,target:likedMovieController){
        print("Save Finished!")
    }
    
}
