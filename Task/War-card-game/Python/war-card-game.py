""" https://bicyclecards.com/how-to-play/war/ """

from numpy.random import shuffle

SUITS = ['♣', '♦', '♥', '♠']
FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
DECK = [f + s for f in FACES for s in SUITS]
CARD_TO_RANK = dict((DECK[i], (i + 3) // 4) for i in range(len(DECK)))


class WarCardGame:
    """ card game War """
    def __init__(self):
        deck = DECK.copy()
        shuffle(deck)
        self.deck1, self.deck2 = deck[:26], deck[26:]
        self.pending = []

    def turn(self):
        """ one turn, may recurse on tie """
        if len(self.deck1) == 0 or len(self.deck2) == 0:
            return self.gameover()

        card1, card2 = self.deck1.pop(0), self.deck2.pop(0)
        rank1, rank2 = CARD_TO_RANK[card1], CARD_TO_RANK[card2]
        print("{:10}{:10}".format(card1, card2), end='')
        if rank1 > rank2:
            print('Player 1 takes the cards.')
            self.deck1.extend([card1, card2])
            self.deck1.extend(self.pending)
            self.pending = []
        elif rank1 < rank2:
            print('Player 2 takes the cards.')
            self.deck2.extend([card2, card1])
            self.deck2.extend(self.pending)
            self.pending = []
        else:  #  rank1 == rank2
            print('Tie!')
            if len(self.deck1) == 0 or len(self.deck2) == 0:
                return self.gameover()

            card3, card4 = self.deck1.pop(0), self.deck2.pop(0)
            self.pending.extend([card1, card2, card3, card4])
            print("{:10}{:10}".format("?", "?"), 'Cards are face down.', sep='')
            return self.turn()

        return True

    def gameover(self):
        """ game over who won message """
        if len(self.deck2) == 0:
            if len(self.deck1) == 0:
                print('\nGame ends as a tie.')
            else:
                print('\nPlayer 1 wins the game.')
        else:
            print('\nPlayer 2 wins the game.')

        return False


if __name__ == '__main__':
    WG = WarCardGame()
    while WG.turn():
        continue
