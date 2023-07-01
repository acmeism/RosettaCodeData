from pokerhand import Card, suit, face
from itertools import product
from random import randrange

class Deck():
    def __init__(self):
        self.__deck = [Card(f, s) for f,s in product(face, suit)]

    def __repr__(self):
        return 'Deck of ' + ' '.join(repr(card) for card in self.__deck)

    def shuffle(self):
        pass

    def deal(self):
        return self.__deck.pop(randrange(len(self.__deck)))

if __name__ == '__main__':
    deck = Deck()
    print('40 cards from a deck:\n')
    for i in range(5):
        for j in range(8):
            print(deck.deal(), end=' ')
        print()
    print('\nThe remaining cards are a', deck)
