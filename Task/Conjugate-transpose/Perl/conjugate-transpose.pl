use strict;
use warnings;
use English;
use Math::Complex;
use Math::MatrixReal;

my @examples = (example1(), example2(), example3());
foreach my $m (@examples) {
    print "Starting matrix:\n", cmat_as_string($m), "\n";
    my $m_ct = conjugate_transpose($m);
    print "Its conjugate transpose:\n", cmat_as_string($m_ct), "\n";
    print "Is Hermitian? ", (cmats_are_equal($m, $m_ct) ? 'TRUE' : 'FALSE'), "\n";
    my $product = $m_ct * $m;
    print "Is normal? ", (cmats_are_equal($product, $m * $m_ct) ? 'TRUE' : 'FALSE'), "\n";
    my $I = identity(($m->dim())[0]);
    print "Is unitary? ", (cmats_are_equal($product, $I) ? 'TRUE' : 'FALSE'), "\n";
    print "\n";
}
exit 0;

sub cmats_are_equal {
    my ($m1, $m2) = @ARG;
    my $max_norm = 1.0e-7;
    return abs($m1 - $m2) < $max_norm;  # Math::MatrixReal overloads abs().
}

# Note that Math::Complex and Math::MatrixReal both overload '~', for
# complex conjugates and matrix transpositions respectively.
sub conjugate_transpose {
    my $m_T = ~ shift;
    my $result = $m_T->each(sub {~ $ARG[0]});
    return $result;
}

sub cmat_as_string {
    my $m = shift;
    my $n_rows = ($m->dim())[0];
    my @row_strings = map { q{[} . join(q{, }, $m->row($ARG)->as_list) . q{]} }
                          (1 .. $n_rows);
    return join("\n", @row_strings);
}

sub identity {
    my $N = shift;
    my $m = Math::MatrixReal->new($N, $N);
    $m->one();
    return $m;
}

sub example1 {
    my $m = Math::MatrixReal->new(2, 2);
    $m->assign(1, 1, cplx(3, 0));
    $m->assign(1, 2, cplx(2, 1));
    $m->assign(2, 1, cplx(2, -1));
    $m->assign(2, 2, cplx(1, 0));
    return $m;
}

sub example2 {
    my $m = Math::MatrixReal->new(3, 3);
    $m->assign(1, 1, cplx(1, 0));
    $m->assign(1, 2, cplx(1, 0));
    $m->assign(1, 3, cplx(0, 0));
    $m->assign(2, 1, cplx(0, 0));
    $m->assign(2, 2, cplx(1, 0));
    $m->assign(2, 3, cplx(1, 0));
    $m->assign(3, 1, cplx(1, 0));
    $m->assign(3, 2, cplx(0, 0));
    $m->assign(3, 3, cplx(1, 0));
    return $m;
}

sub example3 {
    my $m = Math::MatrixReal->new(3, 3);
    $m->assign(1, 1, cplx(0.70710677, 0));
    $m->assign(1, 2, cplx(0.70710677, 0));
    $m->assign(1, 3, cplx(0, 0));
    $m->assign(2, 1, cplx(0, -0.70710677));
    $m->assign(2, 2, cplx(0, 0.70710677));
    $m->assign(2, 3, cplx(0, 0));
    $m->assign(3, 1, cplx(0, 0));
    $m->assign(3, 2, cplx(0, 0));
    $m->assign(3, 3, cplx(0, 1));
    return $m;
}
