use v5.36;
use List::Util 'all';

sub perfect_shuffle (@deck) {
   my $middle = @deck / 2;
   map { @deck[$_, $_ + $middle] } 0..$middle-1;
}

for my $size (8, 24, 52, 100, 1020, 1024, 10000) {
    my @shuffled = my @deck = 1..$size;
    my $n;
    do { $n++; @shuffled = perfect_shuffle @shuffled }
        until all { $shuffled[$_] == $deck[$_] } 0..$#shuffled;
    printf "%5d cards: %4d\n", $size, $n;
}
