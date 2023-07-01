# return an anonymous subroutine that generates stream of specified powers
sub gen_pow {
    my $m = shift;
    my $e = 1;
    return sub { return $e++ ** $m; };
}

# return an anonymous subroutine generator that filters output from supplied generators g1 and g2
sub gen_filter {
    my($g1, $g2) = @_;
    my $v1;
    my $v2 = $g2->();
    return sub {
        while (1) {
            $v1 = $g1->();
            $v2 = $g2->() while $v1 > $v2;
            return $v1 unless $v1 == $v2;
        }
    };
}

my $pow2 = gen_pow(2);
my $pow3 = gen_pow(3);
my $squares_without_cubes = gen_filter($pow2, $pow3);
print "First 30 positive integers that are a square but not a cube:\n";
print $squares_without_cubes->() . ' ' for 1..30;

my $pow6 = gen_pow(6);
print "\n\nFirst 3 positive integers that are both a square and a cube:\n";
print $pow6->() . ' ' for 1..3;
