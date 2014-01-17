import random

class Card(object):
    suits = ("Clubs","Hearts","Spades","Diamonds")
    pips = ("2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace")

    def __init__(self, pip,suit):
        self.pip=pip
        self.suit=suit

    def __str__(self):
        return "%s %s"%(self.pip,self.suit)

class Deck(object):
    def __init__(self):
        self.deck = [Card(pip,suit) for suit in Card.suits for pip in Card.pips]

    def __str__(self):
        return "[%s]"%", ".join( (str(card) for card in self.deck))

    def shuffle(self):
        random.shuffle(self.deck)

    def deal(self):
        self.shuffle()  # Can't tell what is next from self.deck
        return self.deck.pop(0)
