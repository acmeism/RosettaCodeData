print "Enter a variable name: ";
$varname = <STDIN>; # type in "foo" on standard input
chomp($varname);
$$varname = 42; # when you try to dereference a string, it will be
                # treated as a "symbolic reference", where they
                # take the string as the name of the variable
print "$foo\n"; # prints "42"
