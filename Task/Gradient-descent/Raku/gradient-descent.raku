# 20200904 Updated Raku programming solution

sub steepestDescent(@x, $alpha is copy, $h) {

   my $g0 = g |@x ; # Initial estimate of result.

   my @fi = gradG |@x ; #  Calculate initial gradient

   my $b = $alpha / my $delG = sqrt ( sum @fi»² ) ;  # Calculate initial norm.

   while ( $delG > $h ) {   # Iterate until value is <= tolerance.

      @x «-»= $b «*« @fi; #  Calculate next value.

      @fi = gradG |@x ; # Calculate next gradient and next value

      $b = $alpha / ($delG = sqrt( sum @fi»² ));  # Calculate next norm.

      my $g1 = g |@x ;

      $g1 > $g0 ?? ( $alpha /= 2 ) !! ( $g0 = $g1 )   # Adjust parameter.
   }
}

sub gradG(\x,\y) { # gives a rough calculation of gradient g(x).
   2*(x-1)*exp(-y²) - 4*x*exp(-2*x²)*y*(y+2) , -2*(x-1)²*y*exp(-y²) + exp(-2*x²)*(2*y+2)
}

# Function for which minimum is to be found.
sub g(\x,\y) { (x-1)² * exp(-y²) + y*(y+2) * exp(-2*x²) }

my $tolerance = 0.0000006 ; my $alpha = 0.1;

my @x = 0.1, -1; # Initial guess of location of minimum.

steepestDescent(@x, $alpha, $tolerance);

say "Testing steepest descent method:";
say "The minimum is at x[0] = ", @x[0], ", x[1] = ", @x[1];
