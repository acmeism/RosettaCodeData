my $original = 'Hello.';
my $copy = $original;
say $copy;            # prints "Hello."
$copy = 'Goodbye.';
say $copy;            # prints "Goodbye."
say $original;        # prints "Hello."
