//
//  SetGame.swift
//  SetGame2
//
//  Created by AHMED GAMAL  on 4/23/19.
//  Copyright © 2019 AHMED GAMAL . All rights reserved.
//

import Foundation
struct SetGame {
    private let completeDeck : [Card]
    private var actualDeck : Set <Card>
    var Showncards = [Card]()
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    private (set) var score = 0
    
    init (){
        var deck = [Card]()
        let range = 0...2
        for Number in range {
            for color in range{
                for shading in range{
                    for symbol in range{
                        let card = Card (Number : Number, color : color, shading : shading, symbol : symbol )
                        deck.append(card)
                    }
                }
            }
        }
        deck.shuffle()
        self.completeDeck = deck
        actualDeck = Set(deck)
        //intialize shown cards
        for index in 0 ..< 12 {
            actualDeck.remove(deck[index])
            Showncards.append(deck[index])
        }
    }
    //*******************************************************************************************
    //update selected cards array with choosen cards by user
    mutating func isTouchedCardsFormASet ( with touchedCardsIndices : [Int]) -> Bool {
        //- parameter touchedCardsIndices: The indices in the cardsShown array that correspond  to the cards that the user has selected as a guess for a Set match.
        
        for index in touchedCardsIndices{
            assert(Showncards.count > 0 , "setGame , touchThreeCards , index > showncards.count")
            selectedCards.append(Showncards[index])
        }
        
        if isFormingSet(indecies: touchedCardsIndices){
            updateAfterSetFormed(indices: touchedCardsIndices)
            print("after found set22, deck has \(actualDeck.count)")
            score += 6
            return true
        }
        else {
            selectedCards.removeAll()
            score -= 3
            return false
        }
    }
    
    //*******************************************************************************************
    mutating func updateAfterSetFormed (indices : [Int]){
        // remove matched cards to avoid duplication
        for card in selectedCards {
            if actualDeck.count > 0 {actualDeck.remove(card)}
        }
        print("after found set, deck has \(actualDeck.count)")
        
    //we need to replace matched cards with new ones from actualdeck if it not empty else we remove cards from shown view
        for card in selectedCards{
            if let selectedCardIndex = Showncards.index(of : card) {
                //remove from showncards and replace with new one
                if actualDeck.count > 0 {
                    Showncards.insert(actualDeck.popFirst()!, at: selectedCardIndex)
                    Showncards.remove(at: selectedCardIndex + 1)
 // because we inserted new card in the place of matchedcard and matched shifted in set by 1 position(for this reason we created actualdeck as a set to make insertion and deletion and toggling easily)
                }
                else {Showncards.remove(at: selectedCardIndex)}//actualdeck is empty ,we start remove from shown
            }
            // remove matched from selectedcards array
            selectedCards.removeAll()
            //selectedCards.remove(at: selectedCards.index(of: card)!)//we used index of card in selectedCards not selectedCardIndex cause it related to showncards only
        }
        if Showncards.count == 0 {
            resetGame()
        }
    }
    //*******************************************************************************************
    
    //this cards hashvalue has a property that any three cards that form a set : the sum of its hashvalues must be divisible by 3 (0||3||6)
    private func isFormingSet (indecies : [Int]) -> Bool {
        var sum = 0
        for card in selectedCards {
            sum += card.hashValue
        }
        let sumString = String(sum)
        return !sumString.contains("1")
            && !sumString.contains("2")
            && !sumString.contains("4")
            && !sumString.contains("5")
    }
    
    //*******************************************************************************************
    //method to reset new game
    mutating func resetGame() {
        self = SetGame()
    }
    //*******************************************************************************************
    
    mutating func dealThreeCards (){
        guard actualDeck.count > 0 else {return}
        for _ in 1...3 {
            if actualDeck.count > 0{
                
                Showncards.append(actualDeck.popFirst()!)
                
            }
        }
        print("after deal 3 cards deck has \(actualDeck.count)")
        score -= 3
    }
}
//*******************************************************************************************
extension Int {
    var arc4random : Int {
        guard self != 0 else {return 0}
        return Int(arc4random_uniform(UInt32(abs(self))))
    }
}
//*******************************************************************************************
extension Array {
    mutating func shuffle() {
        var last = self.count-1
        guard last > 0 else {return}
        while last > 0 {
            self.swapAt(last.arc4random, last)
            last -= 1
        }
    }
}

