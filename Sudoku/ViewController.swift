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
    
    @IBAction func solveButtonPressed(_ sender: Any)
    {
        //Actually run Algorithm X
    }
}
