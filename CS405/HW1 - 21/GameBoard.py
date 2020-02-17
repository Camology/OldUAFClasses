from Deck import Deck
class GameBoard:
    def __init__(self,players,dealer):
        self.players = players
        self.dealer = dealer
        self.gameNumber = 0
    def newGame(self):
        #PHASE 1 (Initial draws and cleanup from last game)
        for player in self.players:
            player.discardHand()
        self.dealer.discardHand()
        deck = Deck(4 * len(self.players))
        while (len(self.dealer.hand) < 1):
            for player in self.players:
                player.hand.append(deck.dealCard())
                player.hand.append(deck.dealCard())
            self.dealer.hand.append(deck.dealCard())

        #PHASE 2 (players turn)
        # Draw more cards or stay
        for player in self.players:
            playerChoice = player.makeMove(self.players, self.dealer)
            while(playerChoice):
                player.hand.append(deck.dealCard())
                print(player.name + ' was dealt a ' + str(player.hand[len(player.hand)-1]))
                playerChoice = player.makeMove(self.players, self.dealer)

        #PHASE 3 (dealers turn)
        # Draw until 17 points or more
        while(self.dealer.scoreHand() < 17):
            self.dealer.hand.append(deck.dealCard())


        #END PHASE
        self.dealer.scoreHand()
        for player in self.players :
            player.scoreHand()
        if (self.dealer.score == 21):
            self.dealer.wonGame()
        else:
            self.scoreGame()

    def scoreGame(self):
        goal = 21
        playerScores = {}
        for player in self.players:
            if (goal-player.score > -1):
                playerScores[player] = goal-player.score
        dealerScore = goal-self.dealer.score
        sorted_playerScores = sorted(playerScores.items(), key=lambda x: x[1])
        if (len(sorted_playerScores) > 0):
            topPlayer = sorted_playerScores[0]
            if (topPlayer[1] < dealerScore or dealerScore < 0):
                topPlayer[0].wonGame()
            elif (dealerScore < topPlayer[1]):
                self.dealer.wonGame()
            else: 
                print("No winner, try again")
        else:
            self.dealer.wonGame()