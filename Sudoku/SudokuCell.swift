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
        sender.backgroundColor = selectedButton.backgroundColor
        sender.setTitle(selectedButton.currentTitle!, for: .normal)
    }
}
