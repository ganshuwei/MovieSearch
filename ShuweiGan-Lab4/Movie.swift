//
//  Movie.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/29.
//

import Foundation

struct Movie: Decodable {
    let adult: Bool
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
    let original_language: String
} 
