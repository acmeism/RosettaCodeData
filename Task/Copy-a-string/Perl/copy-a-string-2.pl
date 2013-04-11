my $original = 'Hello.';
my $ref = \$original;
$$ref = 'Goodbye.';
print "$original\n";   # prints "Goodbye."
