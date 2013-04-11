package Playing_Card_Deck;

use strict;

@Playing_Card_Deck::suits = qw
   [Diamonds Clubs Hearts Spades];
@Playing_Card_Deck::pips = qw
   [Two Three Four Five Six Seven Eight Nine Ten
    Jack King Queen Ace];
# I choose to fully qualify these names rather than declare them
# with "our" to keep them from escaping into the scope of other
# packages in the same file. Another possible solution is to use
# "our" or "my", but to enclose this entire package in a bare block.

sub new
# Creates a new deck-object. The cards are initially neatly ordered.
 {my $invocant = shift;
  my $class = ref($invocant) || $invocant;
  my @cards = ();
  foreach my $suit (@Playing_Card_Deck::suits)
     {foreach my $pip (@Playing_Card_Deck::pips)
         {push(@cards, {suit => $suit, pip => $pip});}}
  return bless([@cards], $class);}

sub deal
# Removes the top card of the given deck and returns it as a hash
# with the keys "suit" and "pip".
 {return %{ shift( @{shift(@_)} ) };}

sub shuffle
# Randomly permutes the cards in the deck. It uses the algorithm
# described at:
# http://en.wikipedia.org/wiki/Fisher-Yates_shuffle#The_modern_algorithm
 {our @deck; local *deck = shift;
    # @deck is now an alias of the invocant's referent.
  for (my $n = $#deck ; $n ; --$n)
     {my $k = int rand($n + 1);
      @deck[$k, $n] = @deck[$n, $k] if $k != $n;}}

sub print_cards
# Prints out a description of every card in the deck, in order.
 {print "$_->{pip} of $_->{suit}\n" foreach @{shift(@_)};}
