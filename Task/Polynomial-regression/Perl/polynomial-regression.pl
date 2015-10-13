#!bin/usr/perl
use strict;
use warnings;
use 5.020;

#This is a script to calculate an equation for a given set of coordinates.
#Input will be taken in sets of x and y. It can handle a grand total of 26 pairs.
#For matrix functions, we depend on the Math::MatrixReal package.
use Math::MatrixReal;

=pod
Step 1: Get each x coordinate all at once (delimited by " ") and each for y at once
on the next prompt in the same format (delimited by " ").
=cut
sub getPairs() {
    my $buffer = <STDIN>;
    chomp($buffer);
    return split(" ", $buffer);
}
say("Please enter the values for the x coordinates, each delimited by a space. \(Ex: 0 1 2 3\)");
my @x = getPairs();
say("Please enter the values for the y coordinates, each delimited by a space. \(Ex: 0 1 2 3\)");
my @y = getPairs();
#This whole thing depends on the number of x's being the same as the number of y's
my $pairs = scalar(@x);


=pod
Step 2: Devise the base equation of our polynomial using the following idea
There is some polynomial of degree n (n == number of pairs - 1) such that
f(x)=ax^n + bx^(n-1) + ... yx + z
=cut
#Create an array of coefficients and their degrees with the format ("coefficent degree")
my @alphabet;
my @degrees;
for(my $alpha = "a", my $degree = $pairs - 1; $degree >= 0; $degree--, $alpha++) {
    push(@alphabet, "$alpha");
    push(@degrees, "$degree");
}


=pod
Step 3: Using the array of coeffs and their degrees, set up individual equations solving for
each coordinate pair. Why put it in this format? It interfaces witht he Math::MatrixReal package better this way.
=cut
my @coeffs;
for(my $count = 0; $count < $pairs; $count++) {
    my $buffer = "[ ";
    foreach (@degrees) {
        $buffer .= (($x[$count] ** $_) . " ");
    }
    push(@coeffs, ($buffer . "]"));
}
my $row;
foreach (@coeffs) {
    $row .= ("$_\n");
}


=pod
Step 4: We now have rows of x's raised to powers. With this in mind, we create a coefficient matrix.
=cut
my $matrix = Math::MatrixReal->new_from_string($row);
my $buffMatrix = $matrix->new_from_string($row);


=pod
Step 5: Now that we've gotten the matrix to do what we want it to do, we need to calculate the various determinants of the matrices
=cut
my $coeffDet = $matrix->det();


=pod
Step 6: Now that we have the determinant of the coefficient matrix, we need to find the determinants of the coefficient matrix with each column (1 at a time) replaced with the y values.
=cut
#NOTE: Unlike in Perl, matrix indices start at 1, not 0.
for(my $rows = my $column = 1; $column <= $pairs; $column++) {
    #Reassign the values in the current column to the y values
    foreach (@y) {
        $buffMatrix->assign($rows, $column, $_);
        $rows++;
    }
    #Find the values for the variables a, b, ... y, z in the original polynomial
    #To round the difference of the determinants, I had to get creative
    my $buffDet = $buffMatrix->det() / $coeffDet;
    my $tempDet = int(abs($buffDet) + .5);
    $alphabet[$column - 1] = $buffDet >= 0 ? $tempDet : 0 - $tempDet;
    #Reset the buffer matrix and the row counter
    $buffMatrix = $matrix->new_from_string($row);
    $rows = 1;
}


=pod
Step 7: Now that we've found the values of a, b, ... y, z of the original polynomial, it's time to form our polynomial!
=cut
my $polynomial;
for(my $i = 0; $i < $pairs-1; $i++) {
    if($alphabet[$i] == 0) {
        next;
    }
    if($alphabet[$i] == 1) {
        $polynomial .= ($degrees[$i] . " + ");
    }
    if($degrees[$i] == 1) {
        $polynomial .= ($alphabet[$i] . "x" . " + ");
    }
    else {
        $polynomial .= ($alphabet[$i] . "x^" . $degrees[$i] . " + ");
    }
}
#Now for the last piece of the poly: the y-intercept.
$polynomial .= $alphabet[scalar(@alphabet)-1];

print("An approximating polynomial for your dataset is $polynomial.\n");
