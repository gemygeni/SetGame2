//
//  ViewController.swift
//  SetGame2
//
//  Created by AHMED GAMAL  on 4/23/19.
//  Copyright © 2019 AHMED GAMAL . All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    // Mark: view controller properties
        @IBOutlet var cardButtons: [UIButton]!{
        didSet{
            for button in cardButtons {
                button.layer.cornerRadius = 12.0
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.layer.borderWidth = 4.0
            }
        }
    }
    @IBOutlet weak var ScoreLabel: UILabel!{
        didSet{
            ScoreLabel.layer.cornerRadius = 3.0
            ScoreLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ScoreLabel.layer.borderWidth = 4.0
            ScoreLabel.text = " Score🏆 \(setGame.score)"
        }
    }
    //*****************************************************************
    @IBOutlet weak var dealThreeCards: UIButton!{
        didSet{
            dealThreeCards.layer.cornerRadius = 12.0
            dealThreeCards.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dealThreeCards.layer.borderWidth = 4.0
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton!{
        didSet{
            newGameButton.layer.cornerRadius = 12.0
            newGameButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            newGameButton.layer.borderWidth = 4.0
           // setGame.resetGame()
        }
    }
    
    private var selectedButtons = [UIButton](){
        didSet {
            if selectedButtons.count == 3 {
                let  setWasFound = IsSelectedButtonsFormASet()
        selectedButtons.forEach{(button) in button.layer.borderColor = setWasFound ? UIColor.green.cgColor : UIColor.red.cgColor
                    button.isEnabled = !setWasFound
                }
            }
        }
    }
    //*******************************************************************************************
    
    //Mark: view Model properties
    lazy private var setGame = SetGame()
    private var foundSet = false
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
//*******************************************************************************************
    // Mark: view Model action
    @IBAction func TouchCard(_ sender: UIButton) {
        updateForButtonSelection(button :sender)
        ScoreLabel.text = "Score🏆 \(setGame.score)"
    }

    @IBAction func dealThreeCardsTouched(_ sender: UIButton) {
        
        dealThreeCardsAction()
        if setGame.Showncards.count == 24 {
            dealThreeCards.isHidden = true
        }
        ScoreLabel.text = "Score🏆 \(setGame.score)"
        
    }
    @IBAction func newGameTouched(_ sender: UIButton) {
        setGame.resetGame()
        updateViewFromModel()
        dealThreeCards.isHidden = false
        ScoreLabel.text = "Score🏆 \(setGame.score)"
    }
    //*******************************************************************************************
    private func updateForButtonSelection(button : UIButton){
        if selectedButtons.count == 3 {
           selectedButtons.removeAll()
            updateViewFromModel()
        }
        toggleSelection(button)
    }
    
    //*******************************************************************************************
    private func  updateViewFromModel(){
        for (index, button) in cardButtons.enumerated(){
            //to update 12 dealed cards only, we used < not <= cause index start from 0
            if index < setGame.Showncards.count{
                let cardToShown = setGame.Showncards [index]
                let cardText =  createAttributedString(using: cardToShown)
                button.setAttributedTitle(cardText, for: .normal)
                button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                button.isEnabled = true
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                button.layer.borderWidth = 4.0
            }
            else {
                button.backgroundColor = #colorLiteral(red: 0.7623527646, green: 0.9909211993, blue: 0, alpha: 1)
                 button.isEnabled = false
                button.setAttributedTitle(NSAttributedString (string : ""), for: .normal)
            }
        }
    }
    //*******************************************************************************************
    func dealThreeCardsAction() {
        let cardsShown = setGame.Showncards.count
        assert(cardsShown <= 24,
               "ViewController, dealThreeCardsAction(): `cardsShown` is greater than 24")
        guard cardsShown < 24 else { return }
        setGame.dealThreeCards()
        updateViewFromModel()
    }
   // reverse selection state Selects or deselects a button
    private func toggleSelection (_ button : UIButton){
        if selectedButtons.contains(button){
            
            button.layer.borderColor = UIColor.black.cgColor

            selectedButtons.remove(at: selectedButtons.index(of: button)!)
        }
        else {
           
            button.layer.borderColor = UIColor.blue.cgColor
            selectedButtons.append(button)
            
        }
    }
    //*******************************************************************************************
    private func IsSelectedButtonsFormASet () -> Bool{
        var selectedCardsIndices = [Int]()
        for button in selectedButtons {
            if let selectedCardIndex = cardButtons.index (of : button){
              selectedCardsIndices.append(selectedCardIndex)
            }
        }
        return setGame.isTouchedCardsFormASet (with : selectedCardsIndices)
    }
    //*******************************************************************************************
    let colors = [#colorLiteral(red: 0, green: 0.5772432089, blue: 0, alpha: 1) , #colorLiteral(red: 1, green: 0.3501453102, blue: 0, alpha: 1) , #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
    let shapes = ["\u{25A0}", "\u{25B2}", "\u{25CF}"]
    let grayBackgroundColor = UIColor (red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
    
    private func createAttributedString (using card : Card) -> NSAttributedString{
                var attributes = [NSAttributedString.Key : Any]()
                var cardText   : String
        attributes [.strokeColor] = colors [card.color]
        switch card.shading {
        case 0 :attributes [.strokeWidth] = -5.0 // solid
                attributes [.foregroundColor] = attributes [.strokeColor]
        case 1 :  attributes [.foregroundColor] = colors [card.color].withAlphaComponent(0.50)
            
        case 2 : attributes[.strokeWidth] = 5.0
            
        default:
            break
        }
        cardText = String(repeating: shapes[card.symbol], count: card.Number + 1)//becuse card number stert from zero we add one so we repeat 1,2,3
        
        return NSAttributedString (string: cardText , attributes : attributes)
      }
    
    // MARK: End Game Actions & Observers
    @objc private func gameDidEnd() {
        newGameButton.isHidden = false
        dealThreeCards.isEnabled = false
        let alert = UIAlertController(title: "Congratulations!",
                                      message: "You have found all the sets in the deck",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue",
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
      }
    
    //******************************************************************************************
    private func addEndGameObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(gameDidEnd),
                                               name: Notification.Name.init("gameDidEnd"),
                                               object: nil)
        }
    deinit {
        NotificationCenter.default.removeObserver(self)
     }
   }

