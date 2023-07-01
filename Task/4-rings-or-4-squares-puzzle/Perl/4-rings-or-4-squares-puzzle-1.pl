use ntheory qw/forperm/;
use Set::CrossProduct;

sub four_sq_permute {
    my($list) = @_;
    my @solutions;
    forperm {
       @c = @$list[@_];
       push @solutions, [@c] if check(@c);
    } @$list;
    print +@solutions . " unique solutions found using: " . join(', ', @$list) . "\n";
    return @solutions;
}

sub four_sq_cartesian {
    my(@list) = @_;
    my @solutions;
    my $iterator = Set::CrossProduct->new( [(@list) x 7] );
    while( my $c = $iterator->get ) {
       push @solutions, [@$c] if check(@$c);
    }
    print +@solutions . " non-unique solutions found using: " . join(', ', @{@list[0]}) . "\n";
    return @solutions;
}

sub check {
    my(@c) = @_;
    $a = $c[0] + $c[1];
    $b = $c[1] + $c[2] + $c[3];
    $c = $c[3] + $c[4] + $c[5];
    $d = $c[5] + $c[6];
    $a == $b and $a == $c and $a == $d;
}

sub display {
    my(@solutions) = @_;
    my $fmt = "%2s " x 7 . "\n";
    printf $fmt, ('a'..'g');
    printf $fmt, @$_ for @solutions;
    print "\n";
}

display four_sq_permute( [1..7] );
display four_sq_permute( [3..9] );
display four_sq_permute( [8, 9, 11, 12, 17, 18, 20, 21] );
four_sq_cartesian( [0..9] );
