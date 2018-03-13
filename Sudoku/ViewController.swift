//
//  ViewController.swift
//  Sudoku
//
//  Created by Tyler Rife on 3/8/18.
//  Copyright © 2018 Tyler Rife. All rights reserved.
//

import UIKit

var selectedButton: UIButton?
var data = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var solveButton: UIButton!
    
    let cellReuseIdentifier = "Sudoku Cell"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SudokuCell
        let titleInt = data[indexPath.section][indexPath.row]
        let title = titleInt == 0 ? "X" : String(titleInt)
        cell.cellButton.setTitle(title, for: .normal)
        cell.cellButton.backgroundColor = getColorForTitle(title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 96) / 9, height: (UIScreen.main.bounds.width - 96) / 9)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //According to my very brief google search, a board can have a minimum given of 17 for Sudoku. I'm going to use this for the app. It usually has a max of 32 but if people want to help my algorithm out then hey ¯\_(ツ)_/¯
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getColorForTitle(_ title: String) -> UIColor?
    {
        for numberButton in numberButtons
        {
            if numberButton.currentTitle! == title
            {
                return numberButton.backgroundColor!
            }
        }
        return nil
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton)
    {
        selectedButton = sender
    }
    
    func findAndDoMoves()
    {
        var listOfOnePossible: Array<[String: Int]> = Array<[String: Int]>()
        for y in 0..<9
        {
            for x in 0..<9
            {
                if data[x][y] == 0
                {
                    guard let group = checkGroup(x, y) else
                    {
                        return
                    }
                    
                    guard let row = checkRow(x) else
                    {
                        return
                    }
                    
                    guard let column = checkColumn(y) else
                    {
                        return
                    }
                    
                    var unusedValues = [1, 2, 3, 4, 5, 6, 7, 8, 9]
                    for value in group
                    {
                        if unusedValues.contains(value)
                        {
                            unusedValues.remove(at: unusedValues.index(of: value)!)
                        }
                    }
                    for value in row
                    {
                        if unusedValues.contains(value)
                        {
                            unusedValues.remove(at: unusedValues.index(of: value)!)
                        }
                    }
                    for value in column
                    {
                        if unusedValues.contains(value)
                        {
                            unusedValues.remove(at: unusedValues.index(of: value)!)
                        }
                    }
                    if unusedValues.count == 1
                    {
                        listOfOnePossible.append(["\(x),\(y)": unusedValues[0]])
                    }
                }
            }
        }
        guard listOfOnePossible.count > 1 else
        {
            return
        }
        for dictionary in listOfOnePossible
        {
            for (location, value) in dictionary
            {
                let substrings = location.split(separator: ",")
                data[Int(substrings[0])!][Int(substrings[1])!] = value
            }
        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func checkGroup(_ posX: Int, _ posY: Int) -> [Int]?
    {
        var usedNumbers: Array<Int> = Array()
        let xOffset = posX % 3;
        let yOffset = posY % 3;
        for y in 0..<3
        {
            for x in 0..<3
            {
                let currentNumber = data[posX - xOffset + x][posY - yOffset + y]
                if currentNumber != 0
                {
                    usedNumbers.append(currentNumber)
                }
            }
        }
        var unusedNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        for num in usedNumbers
        {
            if unusedNumbers.contains(num)
            {
                unusedNumbers.remove(at: unusedNumbers.index(of: num)!)
            }
            else
            {
                return nil
            }
        }
        return unusedNumbers
    }
    
    func checkRow(_ x: Int) -> [Int]?
    {
        var usedNumbers: Array<Int> = Array()
        for y in 0..<9
        {
            let currentNumber = data[x][y]
            if currentNumber != 0
            {
                usedNumbers.append(currentNumber)
            }
        }
        var unusedNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        for num in usedNumbers
        {
            if unusedNumbers.contains(num)
            {
                unusedNumbers.remove(at: unusedNumbers.index(of: num)!)
            }
            else
            {
                return nil
            }
        }
        return unusedNumbers
    }
    
    func checkColumn(_ y: Int) -> [Int]?
    {
        var usedNumbers: Array<Int> = Array()
        for x in 0..<9
        {
            let currentNumber = data[x][y]
            if currentNumber != 0
            {
                usedNumbers.append(currentNumber)
            }
        }
        var unusedNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        for num in usedNumbers
        {
            if unusedNumbers.contains(num)
            {
                unusedNumbers.remove(at: unusedNumbers.index(of: num)!)
            }
            else
            {
                return nil
            }
        }
        return unusedNumbers
    }
    
    @IBAction func solveButtonPressed(_ sender: Any)
    {
        findAndDoMoves()
    }
}
