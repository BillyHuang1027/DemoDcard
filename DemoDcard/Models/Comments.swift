//
//  Comments.swift
//  DemoDcard
//
//  Created by 黃昌齊 on 2021/5/4.
//

import Foundation

struct Comments: Codable {
    let id: String
    let createdAt: Date
    let content: String
    let floor: Int
    let gender: String
    let school: String?
}
