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
var globalMatrix: SudokuMatrix?

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
    
    /*
     AlgorithmX():
     If Matrix has no Columns
     Terminate with the current solution
     Assign C to the first column in Matrix
     For each Row R in where Matrix[R][C] = 1
     AddRowToSolution(R) and CoverRow(R)
     Recursively call AlgorithmX() on the modified Matrix
     RemoveRowFromSolution(R) and UncoverRow(R)
     CoverRow(R):
     For each Column C where Matrix[R][C] = 1
     For each Row L where Matrix[L][C] = 1
     For each Node N in L
     Cover(N)
     Remove C from Matrix
     UncoverRow(R):
     For each Column C where Matrix[R][C] = 1
     For each Row L where Matrix[L][C] = 1
     For each Node N in L
     Uncover(N)
     Un-remove C from Matrix
     Cover(node):
     Assign node.left.right to node.right
     Assign node.right.left to node.left
     Uncover(node):
     Assign node.left.right to node
     Assign node.right.left to node
    */
    
    @IBAction func solveButtonPressed(_ sender: Any)
    {
        //Actually run Algorithm X
        var matrix: SudokuMatrix!
        if globalMatrix == nil
        {
            matrix = SudokuMatrix(81)
            globalMatrix = matrix
        }
        else
        {
            matrix = globalMatrix!
        }
        print("Started constraint generation")
        let constraints: [[Int]] = matrix.generateConstraints()
        print(constraints.count) //Literally to shut up the compiler.
        print("Finished constraint generation")
    }
}
