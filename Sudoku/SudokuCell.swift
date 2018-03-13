//
//  SudokuCell.swift
//  Sudoku
//
//  Created by Tyler Rife on 3/8/18.
//  Copyright © 2018 Tyler Rife. All rights reserved.
//

import UIKit

class SudokuCell: UICollectionViewCell
{
    @IBOutlet weak var cellButton: UIButton!
    
    @IBAction func onButtonPressed(_ sender: UIButton)
    {
        guard let selectedButton = selectedButton else
        {
            return
        }
        let indexPath = (self.superview as! UICollectionView).indexPath(for: self)!
        let currentTitle = selectedButton.currentTitle!
        data[indexPath.section][indexPath.row] = currentTitle == "X" ? 0 : Int(currentTitle)!
        sender.backgroundColor = selectedButton.backgroundColor
        sender.setTitle(currentTitle, for: .normal)
    }
}
