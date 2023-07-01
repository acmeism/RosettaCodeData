use v6;

grammar PokerHand {

    # Raku Grammar to parse and rank 5-card poker hands
    # E.g. PokerHand.parse("2♥ 3♥ 2♦ 3♣ 3♦");
    # 2013-12-21: handle 'joker' wildcards; maximum of two

    rule TOP {
         :my %*PLAYED;
         { %*PLAYED = () }
         [ <face-card> | <joker> ]**5
    }

    token face-card {<face><suit> <?{
            my $card = ~$/.lc;
            # disallow duplicates
            ++%*PLAYED{$card} <= 1;
       }>
    }

    token joker {:i 'joker' <?{
            my $card = ~$/.lc;
            # allow two jokers in a hand
            ++%*PLAYED{$card} <= 2;
        }>
    }

    token face {:i <[2..9 jqka]> | 10 }
    token suit {<[♥ ♦ ♣ ♠]>}
}

class PokerHand::Actions {
    method TOP($/) {
        my UInt @n    = n-of-a-kind($/);
        my $flush     = 'flush' if flush($/);
        my $straight  = 'straight' if straight($/);
        make rank(@n[0], @n[1], $flush, $straight);
    }
    multi sub rank(5,*@)                    { 'five-of-a-kind' }
    multi sub rank($,$,'flush','straight')  { 'straight-flush' }
    multi sub rank(4,*@)                    { 'four-of-a-kind' }
    multi sub rank($,$,'flush',$)           { 'flush' }
    multi sub rank($,$,$,'straight')        { 'straight' }
    multi sub rank(3,2,*@)                  { 'full-house' }
    multi sub rank(3,*@)                    { 'three-of-a-kind' }
    multi sub rank(2,2,*@)                  { 'two-pair' }
    multi sub rank(2,*@)                    { 'one-pair' }
    multi sub rank(*@)                      { 'high-card' }

    sub n-of-a-kind($/) {
        my %faces := bag @<face-card>.map: -> $/ {~$<face>.lc};
        my @counts = %faces.values.sort.reverse;
        @counts[0] += @<joker>;
        return @counts;
    }

    sub flush($/) {
        my @suits = unique @<face-card>.map: -> $/ {~$<suit>};
        return +@suits == 1;
    }

    sub straight($/) {
        # allow both ace-low and ace-high straights
        constant @Faces = [ "a 2 3 4 5 6 7 8 9 10 j q k a".split: ' ' ];
        constant @Possible-Straights = [ (4 ..^ @Faces).map: { set @Faces[$_-4 .. $_] } ];

        my $faces = set @<face-card>.map: -> $/ {~$<face>.lc};
        my $jokers = +@<joker>;

        return ?( @Possible-Straights.first: { +($faces ∩ $_) + $jokers == 5 } );
    }
}

my PokerHand::Actions $actions .= new;

for ("2♥ 2♦ 2♣ k♣ q♦",   # three-of-a-kind
     "2♥ 5♥ 7♦ 8♣ 9♠",   # high-card
     "a♥ 2♦ 3♣ 4♣ 5♦",   # straight
     "2♥ 3♥ 2♦ 3♣ 3♦",   # full-house
     "2♥ 7♥ 2♦ 3♣ 3♦",   # two-pair
     "2♥ 7♥ 7♦ 7♣ 7♠",   # four-of-a-kind
     "10♥ j♥ q♥ k♥ a♥",  # straight-flush
     "4♥ 4♠ k♠ 5♦ 10♠",  # one-pair
     "q♣ 10♣ 7♣ 6♣ 4♣",  # flush
     "a♥ a♥ 3♣ 4♣ 5♦",   # invalid
     ## EXTRA CREDIT ##
     "joker  2♦  2♠  k♠  q♦",  # three-of-a-kind
     "joker  5♥  7♦  8♠  9♦",  # straight
     "joker  2♦  3♠  4♠  5♠",  # straight
     "joker  3♥  2♦  3♠  3♦",  # four-of-a-kind
     "joker  7♥  2♦  3♠  3♦",  # three-of-a-kind
     "joker  7♥  7♦  7♠  7♣",  # five-of-a-kind
     "joker  j♥  q♥  k♥  A♥",  # straight-flush
     "joker  4♣  k♣  5♦ 10♠",  # one-pair
     "joker  k♣  7♣  6♣  4♣",  # flush
     "joker  2♦ joker  4♠  5♠",  # straight
     "joker  Q♦ joker  A♠ 10♠",  # straight
     "joker  Q♦ joker  A♦ 10♦",  # straight-flush
     "joker  2♦ 2♠  joker  q♦",  # four of a kind
    ) {
    my $rank = do with PokerHand.parse($_, :$actions) {
        .ast;
    }
    else {
        'invalid';
    }
    say "$_: $rank";
}
