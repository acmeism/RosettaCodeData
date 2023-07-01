my @y = <A B C D>; # Array of strings 'A', 'B', 'C', and 'D'
say @y[2]; # the @-sigil requires the container to implement the role Positional
@y[1,2] = 'x','y'; # that's where subscripts and many other things come from
say @y; # OUTPUT«[A x y D]␤» # we start to count at 0 btw.

my $x = @y; # $x is now a reference for the array @y

say $x[1]; # prints 'x' followed by a newline character

my Int $with-type-check; # type checks are enforced by the compiler

my Int:D $defined-i = 10; # definedness can also be asked for and default values are required in that case

my Int:D $after-midnight where * > 24 = 25; # SQL is fun and so is Raku

my \bad = 'good'; # if you don't like sigils
say bad; # you don't have to use them
say "this is quite bad"; # but then string interpolation
say "this is quite {bad}" # becomes more wordy
