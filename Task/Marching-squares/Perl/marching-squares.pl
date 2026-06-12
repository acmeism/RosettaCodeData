use v5.36;
no warnings 'experimental::for_list';
use List::Util 'any';
use enum <E N W S>;

sub X ($a,$b) { my @c; for my $aa (0..$a) { for my $bb (0..$b) { push @c, $aa, $bb } } @c }

sub identify_perimeter(@data) {
    for my ($x,$y) (X $#{$data[0]}, $#data) {
        next unless $data[$y][$x] and $data[$y][$x] != 0;
        my ($path,$cx,$cy,$d,$p) = ('', $x, $y);
        do {
            my $mask;
            for my($dx,$dy,$b) (0,0,1, 1,0,2, 0,1,4, 1,1,8) {
                my ($mx, $my) = ($cx+$dx, $cy+$dy);
                $mask += $b if $mx>1 and $my>1 and $data[$my-1][$mx-1] != 0
            }

            $d = N if any { $mask == $_ } (1, 5,13);
            $d = E if any { $mask == $_ } (2, 3, 7);
            $d = W if any { $mask == $_ } (4,12,14);
            $d = S if any { $mask == $_ } (8,10,11);
            $d = $p == N ? W : E if $mask == 6;
            $d = $p == E ? N : S if $mask == 9;

            $path .= $p = (<E N W S>)[$d];
            $cx += (1, 0,-1,0)[$d];
            $cy += (0,-1, 0,1)[$d];
        } until $cx == $x and $cy == $y;
        return $x, -$y, $path
    }
    exit 'That did not work out...';
}

my @M = ([0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0],
         [0, 0, 1, 1, 0],
         [0, 0, 1, 1, 0],
         [0, 0, 0, 1, 0],
         [0, 0, 0, 0, 0]);

printf "X: %d, Y: %d, Path: %s\n", identify_perimeter(@M);
