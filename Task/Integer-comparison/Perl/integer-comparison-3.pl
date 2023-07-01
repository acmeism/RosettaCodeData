# Get input, test and display
print "Enter two integers: ";
($x, $y) = split ' ', <>;
print $x, (" is less than ", " is equal to ",
           " is greater than ")[test_num($x, $y) + 1], $y, "\n";
