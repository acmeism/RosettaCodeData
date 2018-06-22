my @a =
    [1,2,3],
    [4,5,6],
    [7,8,9];

sub msay(@x) {
    for @x -> @row {
        print ' ', $_%1 ?? $_.nude.join('/') !! $_ for @row;
        say '';
    }
    say '';
}

msay @a «+» @a;
msay @a «-» @a;
msay @a «*» @a;
msay @a «/» @a;
msay @a «+» [1,2,3];
msay @a «-» [1,2,3];
msay @a «*» [1,2,3];
msay @a «/» [1,2,3];
msay @a «+» 2;
msay @a «-» 2;
msay @a «*» 2;
msay @a «/» 2;

# In addition to calling the underlying higher-order functions directly, it's possible to name a function.

sub infix:<M+> (\l,\r) { l <<+>> r }

msay @a M+ @a;
msay @a M+ [1,2,3];
msay @a M+ 2;
