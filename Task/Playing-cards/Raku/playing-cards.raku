enum Pip <A 2 3 4 5 6 7 8 9 10 J Q K>;
enum Suit <♦ ♣ ♥ ♠>;

class Card {
    has Pip $.pip;
    has Suit $.suit;

    method Str { $!pip ~ $!suit }
}

class Deck {
    has Card @.cards = pick *,
            map { Card.new(:$^pip, :$^suit) }, flat (Pip.pick(*) X Suit.pick(*));

    method shuffle { @!cards .= pick: * }

    method deal { shift @!cards }

    method Str  { ~@!cards }
    method gist { ~@!cards }
}

my Deck $d = Deck.new;
say "Deck: $d";

my $top = $d.deal;
say "Top card: $top";

$d.shuffle;
say "Deck, re-shuffled: ", $d;
