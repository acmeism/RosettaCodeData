use v5.12;
use Sub::SmartMatch;
use SmartMatch::Sugar qw(any);
use List::MoreUtils qw( natatime );

my %symbols = (
    1 => "I", 5 => "V", 10 => "X", 50 => "L", 100 => "C",
    500 => "D", 1_000 => "M"
);

my @subtractors = (
        1_000, 100,  500, 100,  100, 10,  50, 10,  10, 1,  5, 1,  1, 0
);

multi roman => [0], sub { '' };
multi roman => any, sub {
    my $n = shift;
    my $iter = natatime 2, @subtractors;
    while( my ($cut, $minus) = $iter->() ) {
        $n >= $cut
            and return $symbols{$cut} . roman($n - $cut);
        $n >= $cut - $minus
            and return $symbols{$minus} . roman($n + $minus);
    }
};

say roman($_) for 1..2_012;
