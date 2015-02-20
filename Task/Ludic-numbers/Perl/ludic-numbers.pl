#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

{   my @ludic = (1);
    my $max = 3;
    my @candidates;

    sub sieve {
        my $l = shift;
        for (my $i = 0; $i <= $#candidates; $i += $l) {
            splice @candidates, $i, 1;
        }
    }

    sub ludic {
        my ($type, $n) = @_;
        die "Arg0 Type must be 'count' or 'max'\n"
             unless grep $_ eq $type, qw( count max );
        die "Arg1 Number must be > 0\n" if 0 >= $n;

        return (@ludic[ 0 .. $n - 1 ]) if 'count' eq $type and @ludic >= $n;

        return (grep $_ <= $n, @ludic) if 'max'   eq $type and $ludic[-1] >= $n;

        while (1) {
            if (@candidates) {
                last if ('max' eq $type and $candidates[0] > $n)
                     or ($n == @ludic);

                push @ludic, $candidates[0];
                sieve($ludic[-1] - 1);

            } else {
                $max *= 2;
                @candidates = 2 .. $max;
                for my $l (@ludic) {
                    sieve($l - 1) unless 1 == $l;
                }
            }
        }
        return (@ludic)
    }

}

my @triplet;
my %ludic;
undef @ludic{ ludic(max => 250) };
for my $i (keys %ludic) {
    push @triplet, $i if exists $ludic{ $i + 2 } and exists $ludic { $i + 6 };
}

say 'First 25:       ', join ' ', ludic(count => 25);
say 'Count < 1000:   ', scalar ludic(max => 1000);
say '2000..2005th:   ', join ' ', (ludic(count => 2005))[1999 .. 2004];
say 'triplets < 250: ', join ' ',
                        map { '(' . join(' ',$_, $_ + 2, $_ + 6) . ')' }
                        sort { $a <=> $b } @triplet;
