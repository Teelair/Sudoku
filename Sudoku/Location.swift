//
//  Location.swift
//  Sudoku
//
//  Created by Tyler Rife on 3/8/18.
//  Copyright © 2018 Tyler Rife. All rights reserved.
//

import UIKit

class Location: Hashable
{
    var hashValue: Int = -1
    
    static func ==(lhs: Location, rhs: Location) -> Bool
    {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func ==(lhs: Location, rhs: Int) -> Bool
    {
        guard let locationFromInt = Location(index: rhs) else
        {
            return false
        }
        
        return lhs.x == locationFromInt.x && lhs.y == locationFromInt.y
    }
    
    static func ==(lhs: Int, rhs: Location) -> Bool
    {
        guard let locationFromInt = Location(index: lhs) else
        {
            return false
        }
        return rhs.x == locationFromInt.x && rhs.y == locationFromInt.y
    }
    
    var x: Int
    var y: Int
    
    init?(_ x: Int, _ y: Int)
    {
        guard x >= 0 && x < 10 && y >= 0 && y < 10 else
        {
            return nil
        }
        self.x = x
        self.y = x
    }
    
    init?(index i: Int)
    {
        guard i >= 0 && i < 82 else
        {
            return nil
        }
        self.x = i % 9
        self.y = (i - x) / 9
    }
}
