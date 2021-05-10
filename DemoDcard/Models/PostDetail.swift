//
//  PostDetail.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/4.
//

import Foundation

struct PostDetail: Codable {
    let content: String
    let createdAt: Date
    let commentCount: Int
    let likeCount: Int
    let mediaMeta: [Media]
}

struct Media: Codable {
    let url: URL
    let width: Int
    let height: Int
}
