//
//  card.swift
//  SetGame2
//
//  Created by AHMED GAMAL  on 4/23/19.
//  Copyright © 2019 AHMED GAMAL . All rights reserved.
//

import Foundation
struct Card : Equatable{
    let Number  : Int
    let color   : Int
    let shading : Int
    let symbol  : Int
    static func == (lhs : Card, rhs : Card) -> Bool{
        return lhs.Number  == rhs.Number
            && lhs.color   == rhs.color
            && lhs.shading == rhs.shading
            && lhs.symbol  == rhs.symbol
    }
}
extension Card : Hashable {
    var hashValue : Int {
        let digits = [Number, color, shading, symbol]
        return Int( digits.map (String.init).joined())!
        //convert array to string, join string member, convert string to integer
    }
}
