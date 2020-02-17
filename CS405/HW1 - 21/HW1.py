""" 
    21 played by an AI and the dealer
    Cameron K Titus
    Rules
    A [1 or 11]
    Face value = value
    JQK = 10
    Suit does not matter

    Deal 2 cards first, dealer shows first card
    3 Player choices
    Hit - Draw another card
    Stand - Stop current total
    Surrender 

    Dealer plays:
    Dealer draws until total of 17 or more, cannot stop drawing

    Winner:
    Players win if dealer busts and AI does not, otherwise whomever is closest to 21. If tie neither win
"""

import time
from Deck import Deck
from Agent import Agent
from GameBoard import GameBoard
from tkinter import *

# Startup game window
# window = Tk()
# window.title("hello world")
# # label =Label(window, text="helloo", font=('Arial Bold', 50))
# # label.grid(column=0,row=0)
# window.geometry('800x400')
# quit = Button(window, text="Quit!", command=window.destroy)
# quit.grid(column=0, row=1)
# playerName = Entry(window, width=10)
# playerName.grid(column=1, row=1)
# window.mainloop()


#Game is running window
players = []

try: 
    agent = Agent(input("Enter your name: ") or "Master Player", "Human")
except ValueError:
    agent = Agent("Human", "Human")
players.append(agent)

try:
    numAgents = int(input("Enter amount of CPU players: ") or 2)
except ValueError:
    print("Not a valid amount of players, default is 2")
iter = 0
while (iter < numAgents) :
    try: 
        agent = Agent(input("Enter the CPU name: ") or "Johnny Q" + str(iter), input("Enter the AI type: ") or "Random")
    except ValueError:
        agent = Agent("Agent" + str(iter), "Random")
    players.append(agent)
    iter+=1

try:
    dealer = Agent(input("Enter the dealers name: ") or "Metzgar the Brave","Dealer")
except ValueError:
    print("Not a valid dealer, default name is Metzgar the Brave")
    dealer = Agent("Metzgar the Brave", "Dealer")

table = GameBoard(players,dealer)
try:
    maxGames = int(input("Enter amount of games to run: ") or 1)
except ValueError:
    print("Not a valid number of games, default is 1000")
    maxGames = 1000
start_Time = time.time()
while(table.gameNumber < maxGames):
    table.gameNumber+=1
    table.newGame()
#player.printStats(table.gameNumber)
#dealer.printStats(table.gameNumber)
print("Total time was: " + str(time.time() - start_Time) + " sec.")

