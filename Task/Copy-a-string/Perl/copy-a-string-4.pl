use Lexical::Alias;
my $original = 'Hello.';
my $alias;
alias $alias, $original;
$alias = 'Good evening.';
print "$original\n";   # prints "Good evening."
