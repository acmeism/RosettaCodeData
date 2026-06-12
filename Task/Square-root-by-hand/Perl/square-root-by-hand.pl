use strict;
use warnings;
use feature 'say';

sub integral   { my($n) = @_; (length($n) % 2 != 0 ? '0' . $n  : $n) =~ /../g }
sub fractional { my($n) = @_; (length($n) % 2 == 0 ? $n  . '0' : $n) =~ /../g }

sub SpigotSqrt {
    my($in) = @_;

    my(@dividends, @fractional, $dividend, $quotient, $remainder, $accum);
    my $d   = 9;
    my $D   = '';
    my $dot = 0;

    if ($in == int $in) {
        @dividends =    integral($in);
    } else {
        @dividends  =   integral($in =~ /(.*)\./);
        @fractional = fractional($in =~ /\.(.*)/);
    }
    $dividend = shift @dividends;

    while () {
        until ( ( $remainder = $dividend - ($D.$d) * $d ) >= 0) { $d-- }

        $accum    .= $d;
        $quotient .= $d;
        unless (@dividends) {
            last if $remainder == 0 and $quotient != 0 and !@fractional;
            unless ($dot) { $accum .= '.' and $dot = 1 }
            if (@fractional) {
                push @dividends, @fractional;
                @fractional = ();
            } else {
                push @dividends, '00';
            }
        }
        $dividend = $remainder . shift @dividends;
        $D = 2 * $quotient;
        $d = 9
    }
    return $accum;
}

say "The square root of $_ is " . SpigotSqrt $_ for < 25 0.0625 152.2756 >;
