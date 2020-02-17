from random import shuffle

class Deck:
    def __init__(self, numberSuits):
        self.cards =[]
        iterator=0
        for iterator in range(numberSuits):
            self.cards += [v for v in range(1,10)] 
            self.cards += [10,10,10,10]
            iterator+=1
        shuffle(self.cards)
    
    def dealCard(self):
        card = self.cards.pop()
        return card