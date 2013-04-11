my $original = 'Hello.';
our $alias;
local *alias = \$original;
$alias = 'Good evening.';
print "$original\n";   # prints "Good evening."
