unit sub MAIN ( :$text=$*IN, :$n=2, :$words=100, );

sub add-to-dict ( $text, :$n=2, ) {
    my @words = $text.words;
    my @prefix = @words.rotor: $n => -$n+1;

    (%).push: @prefix Z=> @words[$n .. *]
}

my %dict = add-to-dict $text, :$n;
my @start-words = %dict.keys.pick.words;
my @generated-text = lazy |@start-words, { %dict{ "@_[ *-$n .. * ]" }.pick } ...^ !*.defined;

put @generated-text.head: $words;
