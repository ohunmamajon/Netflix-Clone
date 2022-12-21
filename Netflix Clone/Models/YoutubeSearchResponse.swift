//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Okhunjon Mamajonov on 2022/12/21.
//

import Foundation
struct YoutubeSearchResponse: Codable{
    let items : [VideElement]
}
struct VideElement: Codable {
    let id : idVideoELement
}
struct idVideoELement: Codable{
    let kind : String
    let videoId: String
}
