# define the deck
my @deck = <2 3 4 5 6 7 8 9 J Q K A> X~ <♠ ♣ ♥ ♦>;
@deck.pick;    # Pick a card
@deck.pick(5); # Draw 5
@deck.pick(*); # Get a shuffled deck
