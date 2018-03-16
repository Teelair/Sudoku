//
//  SudokuMatrix.swift
//  Sudoku
//
//  Created by Tyler Rife on 3/13/18.
//  Copyright © 2018 Tyler Rife. All rights reserved.
//

import UIKit

var matrixCount: Int = 0
var gridSize: Int!

class SudokuMatrix
{
    var matrixLocal: [[SudokuTile]]
    init(_ gridSizeLocal: Int)
    {
        gridSize = gridSizeLocal
        matrixLocal = [[SudokuTile]](repeating: [SudokuTile](repeating: SudokuTile(), count: gridSizeLocal), count: gridSizeLocal)
        for row in matrixLocal
        {
            for cell in row
            {
                cell.postInit()
            }
        }
    }
    
    func getTile(_ index: Int) -> SudokuTile
    {
        let x = index % gridSize
        return matrixLocal[x][(index - x) / gridSize]
    }
    
    func generateConstraints() -> [[Int]]
    {
        let gridSidelength = 9
        let gridSize = 81
        let columns = gridSize * 4
        let rows = gridSize * gridSidelength
        
        var lines: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: rows), count: columns)
        print(lines.count)
        print(lines[0].count)
        
        var xOffset = 0
        var yOffset = 0

        while xOffset < gridSize
        {
            for i in 0..<gridSidelength
            {
                lines[xOffset][i + yOffset] = 1
            }
            xOffset += 1
            yOffset += gridSidelength
        }
        
        xOffset = gridSize;
        yOffset = 0;
        var loopRan = 0
        while xOffset < gridSize * 2 && yOffset < rows
        {
            for i in 0..<gridSidelength
            {
                lines[xOffset + i][yOffset + i] = 1
                if i == 0
                {
                    loopRan += 1
                }
            }
            if loopRan % gridSidelength == 0
            {
                xOffset += gridSidelength
            }
            yOffset += gridSidelength
        }
        xOffset = gridSize * 2
        yOffset = 0
        while xOffset < gridSize * 3 && yOffset < rows
        {
            for i in 0..<gridSidelength
            {
                lines[xOffset + i][yOffset + i] = 1
            }
            xOffset += gridSidelength
            if xOffset >= gridSize * 3
            {
                xOffset = gridSize * 2
            }
            yOffset += gridSidelength
        }
        
        xOffset = gridSize * 3
        yOffset = 0
        
        /*
         * This part will not scale. It somehow works with 9x9 and I am content with that.
         */
        while xOffset < gridSize * 4 && yOffset < rows
        {
            for i in 0..<gridSidelength
            {
                lines[xOffset + i][yOffset + i] = 1
            }
            yOffset += gridSidelength
            if xOffset >= gridSize * 4
            {
                xOffset -= gridSidelength * 3
            }
            if yOffset != 0
            {
                if yOffset % (gridSize * 3) == 0
                {
                    xOffset += gridSidelength
                }
                else if yOffset % (gridSidelength * gridSidelength) == 0
                {
                    xOffset -= gridSidelength * 2
                }
                else if yOffset % (gridSidelength * 3) == 0
                {
                    xOffset += gridSidelength
                }
            }
        }
        return lines
    }
    
    func eliminateConstraints(_ constraints: [[Int]], _ index: Int)
    {
        globalMatrix!.coverRow(Int(floor(Double(index / 9))))
    }
    
    
    func coverRow(_ row: Int)
    {
        for _ in 0..<matrixLocal[0].count
        {
            getTile(row * matrixLocal[0].count).cover()
        }
    }
    
    func uncoverRow(_ row: Int)
    {
        for _ in 0..<matrixLocal[0].count
        {
            getTile(row * matrixLocal[0].count).uncover()
        }
    }
}

class SudokuTile
{
    var index: Int
    var left: SudokuTile!
    var right: SudokuTile!
    var up: SudokuTile!
    var down: SudokuTile!
    
    var leftPointer: SudokuTile!
    var rightPointer: SudokuTile!
    var upPointer: SudokuTile!
    var downPointer: SudokuTile!
    
    init()
    {
        index = matrixCount
    }
    
    func postInit()
    {
        guard let matrix = globalMatrix else
        {
            return
        }
        left = matrix.getTile(index % gridSize == 0 ? index + gridSize : index - 1)
        leftPointer = left
        
        right = matrix.getTile(index % gridSize == gridSize - 1 ? index - gridSize : index + 1)
        rightPointer = right
        
        up = matrix.getTile(index < gridSize ? index + (gridSize * (gridSize - 1)) : index - gridSize)
        upPointer = up
        
        down = matrix.getTile(index > gridSize * (gridSize - 1) ? index - (gridSize * (gridSize - 1)) : index + gridSize)
        downPointer = down
    }
    
    func cover()
    {
        left.rightPointer = right
        right.leftPointer = left
        up.downPointer = down
        down.upPointer = up
    }
    
    func uncover()
    {
        left.rightPointer = self
        right.leftPointer = self
        up.downPointer = self
        down.upPointer = self
    }
}
