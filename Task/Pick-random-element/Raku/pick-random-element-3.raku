# define the deck
my @deck = <2 3 4 5 6 7 8 9 J Q K A> X~ <♠ ♣ ♥ ♦>;
say @deck.pick;    # Pick a card
say @deck.pick(5); # Draw 5
say @deck.pick(*); # Get a shuffled deck
