use v5.36;

# NB: not 'blank' lines, need to be full-width white-space
my $grid1 = <<END;
0 5 1 3 2 2 3 1

0 5 5 0 5 2 4 6

4 3 0 3 6 6 2 0

0 6 2 3 5 1 2 6

1 1 3 0 0 2 4 5

2 1 4 3 3 4 6 6

6 4 5 1 5 4 1 4
END

$grid2 = <<END;
0 0 0 1 1 1 0 2

1 2 2 2 0 3 1 3

2 3 3 3 0 4 1 4

2 4 3 4 4 4 0 5

1 5 2 5 3 5 4 5

5 5 0 6 1 6 2 6

3 6 4 6 5 6 6 6
END

my $grid3 = <<END;
0 0 1 1

0 2 2 2

1 2 0 1
END

sub find ($rows, $cols, $x, $y, $try, $orig) {
    state $solution;
    my $sum = $rows + $cols;
    my $gap = qr/(.{$sum}) (.{$sum})/s;

    if( $x > $y ) {
        $x = 0;
        $solution = $orig |. $try and return if ++$y == $rows;  # solved!
    }

    while ( $try =~ /(?=(?|$x $gap $y|$y $gap $x))/gx ) {       # vertical
        my $new = $try;
        substr $new, $-[0], 2*($rows+$cols)+3, " $1+$2 ";
        find($rows, $cols, $x + 1, $y, $new, $orig );
    }

    while ( $try =~ /(?=$x $y|$y $x)/g ) {                      # horizontal
        my $new = $try;
        substr $new, $-[0], 3, ' + ';
        find($rows, $cols, $x + 1, $y, $new, $orig );
    }

    $solution
}

say find(7, 8, 0, 0, $grid1, $grid1 ) . "\n=======\n\n";
say find(7, 8, 0, 0, $grid2, $grid2 ) . "\n=======\n\n";
say find(3, 4, 0, 0, $grid3, $grid3 ) . "\n=======\n\n";

use constant PI => 2*atan2(1,0);
use ntheory 'factorial';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

my($m,$n, $arrangements)  = (7,8, 1);
for my $j (1 .. $m/2) {
  for my $k (1 .. $n/2) {
    $arrangements *= 4*cos(PI*$j/($m+1))**2 + 4*cos(PI*$k/($n+1))**2
  }
}

printf "%32s:%60s\n", 'Arrangements ignoring values',     comma    $arrangements;
printf "%32s:%60s\n", 'Permutations of 28 dominos',       comma my $permutations = factorial 28;
printf "%32s:%60s\n", 'Flip configurations',              comma my $flips = 2**28;
printf "%32s:%60s\n", 'Permuted arrangements with flips', comma    $flips * $permutations * $arrangements;
