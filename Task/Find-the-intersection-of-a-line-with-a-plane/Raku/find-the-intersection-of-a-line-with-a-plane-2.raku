use Clifford:ver<6.2.1>;

# We pick a (non-degenerate) projective basis and
# we define the dual and meet operators.
my $I = [∧] my ($i, $j, $k, $l) = @e;
sub prefix:<∗>($M) { $M/$I }
sub infix:<∨>($A, $B) { ∗((∗$B)∧(∗$A)) }

my $direction = -$j - $k;

# Homogeneous coordinates of (X, Y, Z) are (X, Y, Z, 1)
my $point = 10*$k + $l;

# A projective line is a bivector
my $line = $direction ∧ $point;

# A projective plane is a trivector
my $plane = (5*$k + $l) ∧ ($k*-$i∧$j∧$k);

# The intersection is the meet
my $m = $line ∨ $plane;

# Affine coordinates of (X, Y, Z, W) are (X/W, Y/W, Z/W)
say $m/($m·$l) X· ($i, $j, $k);
