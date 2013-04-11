my @y = <A B C D>; #Array of strings 'A', 'B', 'C', and 'D'

my $x = @y; # $x is now a reference for the array @y

say $x[1]; # prints 'B' follow by a newline character
