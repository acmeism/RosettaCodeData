use strict;
use warnings;
use feature 'say';

sub parse {
    my($e) = @_;
    $e =~ s/ ([xy])/ 1$1/;
    $e =~ s/[ =\+]//g;
    split /[xy=]/, $e;
}

sub solve {
    my($a1, $b1, $c1, $a2, $b2, $c2) = @_;
    my $X = ( $b2 * $c1  -  $b1 * $c2 )
          / ( $b2 * $a1  -  $b1 * $a2 );
    my $Y = ( $a1 * $X  -  $c1 ) / -$b1;
    return $X, $Y;
}

say my $result = join ' ', solve( parse('3x + y = -1'), parse('2x - 3y = -19') );
