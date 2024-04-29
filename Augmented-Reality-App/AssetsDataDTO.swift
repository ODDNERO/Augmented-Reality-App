//
//  AssetsDataDTO.swift
//  Augmented-Reality-App
//

import Foundation

// MARK: - Marker
struct AssetsData: Decodable {
    let title, description: String
}

typealias Marker = [String: AssetsData]
