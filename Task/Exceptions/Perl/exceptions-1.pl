# throw an exception
die "Danger, danger, Will Robinson!";

# catch an exception and show it
eval {
    die "this could go wrong mightily";
};
print $@ if $@;

# rethrow
die $@;
