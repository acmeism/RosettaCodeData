use strict;
use warnings;
use feature 'say';

sub fpermute {
    my($f,@a) = @_;
    my @f = split /\./, $f;
    for (0..$#f) {
        my @b = @a[$_ ..  $_+$f[$_]];
        unshift @b, splice @b, $#b, 1; # rotate(-1)
        @a[$_ .. $_+$f[$_]] = @b;
    }
    join '', @a;
}

sub base {
    my($n) = @_;
    my @digits;
    push(@digits, int $n/$_) and $n = $n % $_ for <6 2 1>; # reverse <1! 2! 3!>
    join '.', @digits;
}

say 'Generate table';

for (0..23) {
    my $x = base($_);
    say $x . ' -> ' . fpermute($x, <0 1 2 3>)
}

say "\nGenerate the given task shuffles";
my @omega = qw<A♠ K♠ Q♠ J♠ 10♠ 9♠ 8♠ 7♠ 6♠ 5♠ 4♠ 3♠ 2♠ A♥ K♥ Q♥ J♥ 10♥ 9♥ 8♥ 7♥ 6♥ 5♥ 4♥ 3♥ 2♥ A♦ K♦ Q♦ J♦ 10♦ 9♦ 8♦ 7♦ 6♦ 5♦ 4♦ 3♦ 2♦ A♣ K♣ Q♣ J♣ 10♣ 9♣ 8♣ 7♣ 6♣ 5♣ 4♣ 3♣ 2♣>;

my @books = (
'39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0',
'51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1'
);

say "Original deck:";
say join '', @omega;

say "\n$_\n" . fpermute($_,@omega) for @books;

say "\nGenerate a random shuffle";
say my $shoe = join '.', map { int rand($_) } reverse 0..$#omega;
say fpermute($shoe,@omega);
