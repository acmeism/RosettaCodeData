use strict;
use feature 'say';

sub cantor {
    our($height) = @_;
    my $width = 3 ** ($height - 1);

    our @lines = ('#' x $width) x $height;

    sub trim_middle_third {
        my($len, $start, $index) = @_;
        my $seg = int $len / 3
            or return;

        for my $i ( $index .. $height - 1 ) {
          for my $j ( 0 .. $seg - 1 ) {
            substr $lines[$i], $start + $seg + $j, 1, ' ';
          }
        }

        trim_middle_third( $seg, $start + $_, $index + 1 ) for 0, $seg * 2;
    }

    trim_middle_third( $width, 0, 1 );
    @lines;
}

say for cantor(5);
