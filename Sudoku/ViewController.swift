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
var allowedBitFields: [Int] = [Int](repeating: 0, count: 10)
var allAllowed: Int!

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
        allowedBitFields[0] = 0
        allowedBitFields[1] = 1
        allowedBitFields[2] = 1 << 1
        allowedBitFields[3] = 1 << 2
        allowedBitFields[4] = 1 << 3
        allowedBitFields[5] = 1 << 4
        allowedBitFields[6] = 1 << 5
        allowedBitFields[7] = 1 << 6
        allowedBitFields[8] = 1 << 7
        allowedBitFields[9] = 1 << 8
        allAllowed = arraySum(allowedBitFields)
        
        /*
        Debug:
        let board = [
            [8,0,0,0,0,0,0,0,0],
            [0,0,3,6,0,0,0,0,0],
            [0,7,0,0,9,0,2,0,0],
            [0,5,0,0,0,7,0,0,0],
            [0,0,0,0,4,5,7,0,0],
            [0,0,0,1,0,0,0,3,0],
            [0,0,1,0,0,0,0,6,8],
            [0,0,8,5,0,0,0,1,0],
            [0,9,0,0,0,0,4,0,0]
        ]
        /*let board = [
         [1,0,0,0,0,7,0,9,0],
         [0,3,0,0,2,0,0,0,8],
         [0,0,9,6,0,0,5,0,0],
         [0,0,5,3,0,0,9,0,0],
         [0,1,0,0,8,0,0,0,2],
         [6,0,0,0,0,4,0,0,0],
         [3,0,0,0,0,0,0,1,0],
         [0,4,1,0,0,0,0,0,7],
         [0,0,7,0,0,0,3,0,0]
         ]*/
        data = board*/
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        if size.width > size.height
        {
            //Landscape
            stackView.axis = UILayoutConstraintAxis.horizontal
        }
        else
        {
            //Portrait
            stackView.axis = UILayoutConstraintAxis.vertical
        }
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
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func solveButtonPressed(_ sender: UIButton)
    {
        resultLabel.text = ""
        if sender.titleLabel!.text == "Solve!"
        {
            if(isBoardValid())
            {
                let before = NSCalendar.current.dateComponents([.nanosecond], from: Date()).nanosecond
                let placedNumbers: Int = solveBoard(&data)
                let after = NSCalendar.current.dateComponents([.nanosecond], from: Date()).nanosecond
                print("Took \(Double(after! - before!) / 1000000)ms to complete.")
                collectionView.reloadData()
                sender.setTitle("Reset", for: .normal)
                resultLabel.text = placedNumbers == 81 ? "Solution found!" : "No solution."
            }
            else
            {
                resultLabel.text = "Invalid board!"
            }
        }
        else
        {
            sender.setTitle("Solve!", for: .normal)
            data = [[Int]](repeating: [Int](repeating: 0, count: 9), count: 9)
            collectionView.reloadData()
        }
    }
    
    func solveBoard(_ board: inout [[Int]]) -> Int
    {
        var allowedValues = [[Int]](repeating: [Int](repeating: allAllowed, count: 9), count: 9)
        var placedNumberCount = 0
        
        for x in 0..<9
        {
            for y in 0..<9
            {
                if board[x][y] > 0
                {
                    allowedValues[x][y] = 0
                    applyAllowedValuesMask(&board, &allowedValues, x, y)
                    placedNumberCount += 1
                }
            }
        }
        return solveBoard(&board, &allowedValues, &placedNumberCount)
    }
    
    func solveBoard(_ board: inout [[Int]], _ allowedValues: inout [[Int]], _ placedNumberCount: inout Int) -> Int
    {
        var lastPlacedNumbersCount = 0
        while placedNumberCount - lastPlacedNumbersCount > 3 && placedNumberCount < 63 && placedNumberCount > 10
        {
            lastPlacedNumbersCount = placedNumberCount
            placedNumberCount += moveNothingElseAllowed(&board, &allowedValues)
            placedNumberCount += moveNoOtherRowOrColumnAllowed(&board, &allowedValues)
            placedNumberCount += moveNothingElseAllowed(&board, &allowedValues)
            if placedNumberCount < 35
            {
                applyNakedPairs(&allowedValues)
                applyLineCandidateConstraints(&allowedValues)
            }
        }
        
        if placedNumberCount < 81
        {
            let bruteForcedBoard = attemptBruteForce(board, allowedValues, placedNumberCount)
            if bruteForcedBoard != nil
            {
                placedNumberCount = 0
                for x in 0..<9
                {
                    for y in 0..<9
                    {
                        board[x][y] = bruteForcedBoard![x][y]
                        if bruteForcedBoard![x][y] > 0
                        {
                            placedNumberCount += 1
                        }
                    }
                }
            }
        }
        return placedNumberCount
    }
    
    func attemptBruteForce(_ board: [[Int]], _ allowedValues: [[Int]], _ placedNumberCount: Int) -> [[Int]]?
    {
        for x in 0..<9
        {
            let allowedValuesRow = allowedValues[x]
            let boardRow = board[x]
            for y in 0..<9
            {
                if boardRow[y] == 0
                {
                    for value in 1...9
                    {
                        if (allowedValuesRow[y] & allowedBitFields[value]) > 0
                        {
                            var testBoard = copyGameMatrix(board)
                            var testAllowedValues = copyGameMatrix(allowedValues)
                            setValue(&testBoard, &testAllowedValues, value, x, y)
                            var localPlacedNumber = placedNumberCount + 1
                            
                            let placedNumbers = solveBoard(&testBoard, &testAllowedValues, &localPlacedNumber)
                            
                            if placedNumbers == 81
                            {
                                return testBoard
                            }
                        }
                    }
                    return nil
                }
            }
        }
        return nil
    }
    
    func moveNoOtherRowOrColumnAllowed(_ board: inout [[Int]], _ allowedValues: inout [[Int]]) -> Int
    {
        var moveCount = 0
        for value in 1...9
        {
            let allowedBitField = allowedBitFields[value]
            
            for x in 0..<9
            {
                var allowedY = -1
                let allowedValuesRow = allowedValues[x]
                
                for y in 0..<9
                {
                    if (allowedValuesRow[y] & allowedBitField) > 0
                    {
                        if allowedY < 0
                        {
                            allowedY = y
                        }
                        else
                        {
                            allowedY = -1
                            break
                        }
                    }
                }
                
                if allowedY >= 0
                {
                    setValue(&board, &allowedValues, value, x, allowedY)
                    moveCount += 1
                }
            }
            
            for y in 0..<9
            {
                var allowedX = -1
                for x in 0..<9
                {
                    if (allowedValues[x][y] & allowedBitField) > 0
                    {
                        if allowedX < 0
                        {
                            allowedX = x
                        }
                        else
                        {
                            allowedX = -1
                            break
                        }
                    }
                }
                if allowedX >= 0
                {
                    setValue(&board, &allowedValues, value, allowedX, y)
                    moveCount += 1
                }
            }
        }
        return moveCount
    }
    
    func moveNothingElseAllowed(_ board: inout [[Int]], _ allowedValues: inout [[Int]]) -> Int
    {
        var moveCount = 0
        for x in 0..<9
        {
            for y in 0..<9
            {
                if countSetBits(allowedValues[x][y]) == 1
                {
                    setValue(&board, &allowedValues, getLastSetBitIndex(allowedValues[x][y]), x, y)
                    moveCount += 1
                }
            }
        }
        return moveCount
    }
    
    func applyNakedPairs(_ allowedValues: inout [[Int]])
    {
        for x in 0..<9
        {
            for y in 0..<9
            {
                let value: Int = allowedValues[x][y]
                if countSetBits(value) == 2
                {
                    for scanningY in y + 1..<9
                    {
                        if allowedValues[x][scanningY] == value
                        {
                            let removeMask: Int = ~value
                            for applyY in 0..<9
                            {
                                if applyY != y && applyY != scanningY
                                {
                                    allowedValues[x][applyY] &= removeMask
                                }
                            }
                        }
                    }
                }
            }
        }
        for y in 0..<9
        {
            for x in 0..<9
            {
                let value: Int = allowedValues[x][y]
                if value != 0 && countSetBits(value) == 2
                {
                    for scanningX in x + 1..<9
                    {
                        if allowedValues[scanningX][y] == value
                        {
                            let removeMask: Int = ~value
                            for applyX in 0..<9
                            {
                                if applyX != x && applyX != scanningX
                                {
                                    allowedValues[applyX][y] &= removeMask
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func applyLineCandidateConstraints(_ allowedValues: inout [[Int]])
    {
        for value in 1...9
        {
            let valueMask: Int = allowedBitFields[value]
            let valueRemoveMask: Int = ~valueMask
            var sectionAvailabilityColumn: [Int] = [Int](repeating: 0, count: 9)
            
            for x in 0..<9
            {
                let finalX = x
                for y in 0..<9
                {
                    if (allowedValues[finalX][y] & valueMask) != 0
                    {
                        sectionAvailabilityColumn[finalX] |= (1 << (y / 3))
                    }
                }
                if finalX == 2 || finalX == 5 || finalX == 8
                {
                    for scanningX in finalX - 2...finalX
                    {
                        let bitCount = countSetBits(sectionAvailabilityColumn[scanningX])
                        if bitCount == 1
                        {
                            for applyX in finalX - 2...finalX
                            {
                                if scanningX != applyX
                                {
                                    for applySectionY in 0..<3
                                    {
                                        if (sectionAvailabilityColumn[scanningX] & (1 << applySectionY)) != 0
                                        {
                                            for applyY in applySectionY * 3..<(applySectionY + 1) * 3
                                            {
                                                allowedValues[applyX][applyY] &= valueRemoveMask
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if bitCount == 2 && scanningX < finalX
                        {
                            for scanningSecondPairX in scanningX + 1...finalX
                            {
                                if sectionAvailabilityColumn[scanningX] == sectionAvailabilityColumn[scanningSecondPairX]
                                {
                                    let applyX: Int
                                    if scanningSecondPairX != finalX
                                    {
                                        applyX = finalX
                                    }
                                    else if scanningSecondPairX - scanningX > 1
                                    {
                                        applyX = scanningSecondPairX - 1
                                    }
                                    else
                                    {
                                        applyX = scanningX - 1
                                    }
                                    
                                    for applySectionY in 0..<3
                                    {
                                        if (sectionAvailabilityColumn[scanningX] & (1 << applySectionY)) != 0
                                        {
                                            for applyY in applySectionY * 3..<(applySectionY + 1) * 3
                                            {
                                                allowedValues[applyX][applyY] &= valueRemoveMask
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }
            var sectionAvailabilityRow = [Int](repeating: 0, count: 9)
            for y in 0..<9
            {
                let finalY = y
                for x in 0..<9
                {
                    if (allowedValues[x][finalY] & valueMask) != 0
                    {
                        sectionAvailabilityRow[finalY] |= (1 << (x / 3))
                    }
                }
                
                if finalY == 2 || finalY == 5 || finalY == 8
                {
                    for scanningY in finalY - 2...finalY
                    {
                        let bitCount = countSetBits(sectionAvailabilityRow[scanningY])
                        if bitCount == 1
                        {
                            for applyY in finalY - 2...finalY
                            {
                                if scanningY != applyY
                                {
                                    for applySectionX in 0..<3
                                    {
                                        if (sectionAvailabilityRow[scanningY] & (1 << applySectionX)) != 0
                                        {
                                            for applyX in applySectionX * 3..<(applySectionX + 1) * 3
                                            {
                                                allowedValues[applyX][applyY] &= valueRemoveMask
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if bitCount == 2 && scanningY < finalY
                        {
                            for scanningSecondPairY in scanningY+1...finalY
                            {
                                if sectionAvailabilityRow[scanningY] == sectionAvailabilityRow[scanningSecondPairY]
                                {
                                    let applyY: Int
                                    if scanningSecondPairY != finalY
                                    {
                                        applyY = finalY
                                    }
                                    else if scanningSecondPairY - scanningY > 1
                                    {
                                        applyY = scanningSecondPairY - 1
                                    }
                                    else
                                    {
                                        applyY = scanningY - 1
                                    }
                                    
                                    for applySectionX in 0..<3
                                    {
                                        if (sectionAvailabilityRow[scanningY] & (1 << applySectionX)) != 0
                                        {
                                            for applyX in applySectionX * 3..<(applySectionX + 1) * 3
                                            {
                                                allowedValues[applyX][applyY] &= valueRemoveMask
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setValue(_ board: inout [[Int]], _ allowedValues: inout [[Int]], _ value: Int, _ x: Int, _ y: Int)
    {
        board[x][y] = value
        allowedValues[x][y] = 0
        applyAllowedValuesMask(&board, &allowedValues, x, y)
    }
    
    func getLastSetBitIndex(_ value: Int) -> Int
    {
        var value = value
        var bitIndex: Int = 0
        while value > 0
        {
            bitIndex += 1
            value >>= 1
        }
        return bitIndex
    }
    
    func applyAllowedValuesMask(_ board: inout [[Int]], _ allowedValues: inout [[Int]], _ x: Int, _ y: Int)
    {
        let mask: Int = ~allowedBitFields[board[x][y]]
        for maskApplyX in 0..<9
        {
            allowedValues[maskApplyX][y] &= mask
        }
        for maskApplyY in 0..<9
        {
            allowedValues[x][maskApplyY] &= mask
        }
        
        var sectionX1: Int = 0
        var sectionX2: Int = 0
        
        switch(x)
        {
        case 0,3,6:
            sectionX1 = x + 1
            sectionX2 = x + 2
            break
        case 1,4,7:
            sectionX1 = x - 1
            sectionX2 = x + 1
            break
        case 2,5,8:
            sectionX1 = x - 2
            sectionX2 = x - 1
            break
        default:
            break
        }
        
        var sectionY1: Int = 0
        var sectionY2: Int = 0
        
        switch(y)
        {
        case 0,3,6:
            sectionY1 = y + 1
            sectionY2 = y + 2
            break
        case 1,4,7:
            sectionY1 = y - 1
            sectionY2 = y + 1
            break
        case 2,5,8:
            sectionY1 = y - 2
            sectionY2 = y - 1
            break
        default:
            break
        }
        
        allowedValues[sectionX1][sectionY1] &= mask
        allowedValues[sectionX1][sectionY2] &= mask
        allowedValues[sectionX2][sectionY1] &= mask
        allowedValues[sectionX2][sectionY2] &= mask
    }
    
    func countSetBits(_ value: Int) -> Int
    {
        var value = value
        var count: Int = 0
        while value > 0
        {
            value = value & (value - 1)
            count += 1
        }
        return count
    }
    
    func arraySum(_ array: [Int]) -> Int
    {
        var sum: Int = 0
        for value in array
        {
            sum += value
        }
        return sum
    }
    
    func copyGameMatrix(_ matrix: [[Int]]) -> [[Int]]
    {
        let copy: [[Int]] = matrix
        return copy
    }
    
    func isBoardValid() -> Bool
    {
        for r in 0..<9
        {
            var unusedValues = [Int](repeating: 0, count: 9)
            for i in 0..<9
            {
                let num = data[r][i]
                if num != 0
                {
                    if unusedValues[num - 1] != 0
                    {
                        return false
                    }
                    else
                    {
                        unusedValues[num - 1] = num
                    }
                }
            }
        }
        for c in 0..<9
        {
            var unusedValues = [Int](repeating: 0, count: 9)
            for i in 0..<9
            {
                let num = data[i][c]
                if num != 0
                {
                    if unusedValues[num - 1] != 0
                    {
                        return false
                    }
                    else
                    {
                        unusedValues[num - 1] = num
                    }
                }
            }
        }
        for group in 0..<9
        {
            var unusedValues = [Int](repeating: 0, count: 9)
            for r in 0..<3
            {
                for c in 0..<3
                {
                    let num = data[r + group % 3 * 3][c + group / 3 * 3]
                    if num != 0
                    {
                        if unusedValues[num - 1] != 0
                        {
                            return false
                        }
                        else
                        {
                            unusedValues[num - 1] = num
                        }
                    }
                }
            }
        }
        return true
    }
}
