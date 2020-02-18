my $a = 12;
our $b; # you can overlay only global variables (this line is only for strictness)
*b = \$a;
print $b; # prints 12
$b++;
print $a; # prints 13
