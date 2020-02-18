my $a = 12;
my $b = \$a; # get reference
$$b = $$b + 30; # access referenced value
print $a; # prints 42
