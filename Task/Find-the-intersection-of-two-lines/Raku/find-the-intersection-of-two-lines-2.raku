use Clifford;

# We pick a projective basis,
# and we compute its pseudo-scalar and its square.
my ($i, $j, $k) = @e;
my $I = $i∧$j∧$k;
my $I2 = ($I**2).narrow;

# Homogeneous coordinates of point (X,Y) are (X,Y,1)
my $A =  4*$i +  0*$j + $k;
my $B =  6*$i + 10*$j + $k;
my $C =  0*$i +  3*$j + $k;
my $D = 10*$i +  7*$j + $k;

# We form lines by joining points
my $AB = $A∧$B;
my $CD = $C∧$D;

# The intersection is their meet, which we
# compute by using the De Morgan law
my $ab = $AB*$I/$I2;
my $cd = $CD*$I/$I2;
my $M = ($ab ∧ $cd)*$I/$I2;

# Affine coordinates are (X/Z, Y/Z)
say $M/($M·$k) X· $i, $j;
