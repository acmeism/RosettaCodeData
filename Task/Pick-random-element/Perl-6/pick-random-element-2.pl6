# define the deck
constant deck = 2..9, <J Q K A> X~ <♠ ♣ ♥ ♦>;
deck.pick;    # Pick a card
deck.pick(5); # Draw 5
deck.pick(*); # Get a shuffled deck
