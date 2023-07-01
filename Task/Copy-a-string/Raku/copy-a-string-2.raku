my $original = 'Hello.';
my $bound := $original;
say $bound;           # prints "Hello."
$bound = 'Goodbye.';
say $bound;           # prints "Goodbye."
say $original;        # prints "Goodbye."
