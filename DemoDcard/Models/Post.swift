//
//  Post.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/1.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let excerpt: String
    let commentCount: Int
    let likeCount: Int
    let forumName: String
    let gender: String
    let school: String?
    let mediaMeta: [MediaMeta]
}

struct MediaMeta: Codable {
    let url: URL
}
