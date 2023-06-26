//
//  APIResults.swift
//  ShuweiGan-Lab4
//
//  Created by 甘书玮 on 2022/10/29.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
