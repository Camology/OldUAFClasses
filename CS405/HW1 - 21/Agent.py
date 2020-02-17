from Deck import Deck
from collections import Counter
from random import randint 

class Agent:
    def __init__(self, name, agentType):
        self.name = name
        self.hand=[]
        self.score = 0
        self.wins = 0
        self.type = agentType

    def wonGame(self):
        print("Congratuations " + self.name + ", you won!")
        print("Winning hand: ")
        self.printHand()
        print("Winning score: " + str(self.scoreHand()) + "\n ~~~~")
        self.wins+=1

    def printStats(self, gameNum):
        print(self.name + " has won: " +  str(self.wins) 
        + " Times, " + str((float(self.wins)/gameNum)*100) 
        + "% of the games")

    def scoreHand(self):
        self.score = 0
        ace = 0
        for card in self.hand:
            if (card ==1):
                ace +=1
            else:
                self.score += int(card)
        for x in range(0, ace):
            if (self.score+11 <= 21):
                self.score+=11
            else:
                self.score+=1
        return self.score

    def printHand(self):
        for card in self.hand:
            print(card)

    def discardHand(self):
        self.hand.clear()
        
    def advancedChoice(self, players, dealer):
        self.scoreHand()
        ourDeck = Deck(4 * len(players))
        goal = range(1,22-self.score)
        othersGoals = []
        for player in players:    
            for card in player.hand:
                ourDeck.cards.remove(card)
        for card in dealer.hand:
            ourDeck.cards.remove(card)

        count = Counter(ourDeck.cards)
        pullChance = 0
        for value in goal:
            pullChance+= (float(count[value])/len(ourDeck.cards))
        return (0.25 < (pullChance))
    
    def humanMove(self): 
        self.scoreHand()
        if (self.score > 21):
            print("Busted 21, sorry")
            return False
        print("Current Hand:")
        self.printHand()
        print("Current Score: " + str(self.score))
        choice = input("Y to hit: ")
        if (choice == "Y" or choice == 'y'):
            return True
        else: return False

    def makeMove(self, players, dealer):
        if (self.type == 'Human'):
            playerChoice = self.humanMove()
        elif (self.type == 'Advanced'):
            playerChoice = self.advancedChoice(players, dealer)
        else:
            playerChoice = randint(0,1)     
        return playerChoice