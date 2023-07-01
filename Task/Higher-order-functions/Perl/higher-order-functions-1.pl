sub another {
    # take a function and a value
    my $func = shift;
    my $val  = shift;

    # call the function with the value as argument
    return $func->($val);
};

sub reverser {
    return scalar reverse shift;
};

# pass named coderef
print another \&reverser, 'data';
# pass anonymous coderef
print another sub {return scalar reverse shift}, 'data';

# if all you have is a string and you want to act on that,
# set up a dispatch table
my %dispatch = (
    square => sub {return shift() ** 2},
    cube   => sub {return shift() ** 3},
    rev    => \&reverser,
);

print another $dispatch{$_}, 123 for qw(square cube rev);
