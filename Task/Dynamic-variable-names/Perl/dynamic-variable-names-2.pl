use strict;

print "Enter a variable name: ";
my $foo;
my $varname = <STDIN>; # type in "foo" on standard input
chomp($varname);
my $varref = eval('\$' . $varname);
$$varref = 42;
print "$foo\n"; # prints "42"
