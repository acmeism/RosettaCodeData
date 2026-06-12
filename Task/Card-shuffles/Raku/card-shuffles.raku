sub overhand ( @cards ) {
    my @splits = roll 10, ^( @cards.elems div 5 )+1;
    @cards.rotor( @splits  ,:partial ).reverse.flat
}

sub riffle ( @pile is copy ) {
    my @pile2 = @pile.splice: @pile.elems div 2 ;

    roundrobin(
        @pile.rotor(  (1 .. 3).roll(7), :partial ),
        @pile2.rotor( (1 .. 3).roll(9), :partial ),
    ).flat
}

my @cards = ^20;
@cards.=&overhand for ^10;
say @cards;

my @cards2 = ^20;
@cards2.=&riffle for ^10;
say @cards2;

say (^20).pick(*);
