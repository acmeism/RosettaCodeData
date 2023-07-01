use autodie;
use List::MoreUtils qw(each_array);

sub writedat {
    my ($filename, $x, $y, $xprecision, $yprecision) = @_;
    open my $fh, ">", $filename;

    my $ea = each_array(@$x, @$y);
    while ( my ($i, $j) = $ea->() ) {
        printf $fh "%.*g\t%.*g\n", $xprecision||3, $i, $yprecision||5, $j;
    }

    close $fh;
}

my @x = (1, 2, 3, 1e11);
my @y = map sqrt, @x;

writedat("sqrt.dat", \@x, \@y);
