use autodie;

sub writedat {
    my ($filename, $x, $y, $xprecision, $yprecision) = @_;

    open my $fh, ">", $filename;

    for my $i (0 .. $#$x) {
        printf $fh "%.*g\t%.*g\n", $xprecision||3, $x->[$i], $yprecision||5, $y->[$i];
    }

    close $fh;
}

my @x = (1, 2, 3, 1e11);
my @y = map sqrt, @x;

writedat("sqrt.dat", \@x, \@y);
