use Math::Matrix;

sub cramers_rule {
    my ($A, $terms) = @_;
    my @solutions;
    my $det = $A->determinant;
    foreach my $i (0 .. $#{$A}) {
        my $Ai = $A->clone;
        foreach my $j (0 .. $#{$terms}) {
            $Ai->[$j][$i] = $terms->[$j];
        }
        push @solutions, $Ai->determinant / $det;
    }
    @solutions;
}

my $matrix = Math::Matrix->new(
    [2, -1,  5,  1],
    [3,  2,  2, -6],
    [1,  3,  3, -1],
    [5, -2, -3,  3],
);

my $free_terms = [-3, -32, -47, 49];
my ($w, $x, $y, $z) = cramers_rule($matrix, $free_terms);

print "w = $w\n";
print "x = $x\n";
print "y = $y\n";
print "z = $z\n";
