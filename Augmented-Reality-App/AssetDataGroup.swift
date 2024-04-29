//
//  AssetDataGroup.swift
//  Augmented-Reality-App
//

import Foundation

enum AssetDataGroup: CaseIterable, Decodable {
    case origin
    case picture
    case real

    var description: String {
        switch self {
        case .origin:
            return "Origin"
        case .picture:
            return "Picture"
        case .real:
            return "Real"
        }
    }
}
