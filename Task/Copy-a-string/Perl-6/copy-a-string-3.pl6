my $original = 'Hello.';
my $bound-ro ::= $original;
say $bound-ro;        # prints "Hello."
try {
  $bound-ro = 'Runtime error!';
  CATCH {
    say "$!";         # prints "Cannot modify readonly value"
  };
};
say $bound-ro;        # prints "Hello."
$original = 'Goodbye.';
say $bound-ro;        # prints "Goodbye."
