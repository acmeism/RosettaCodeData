my $foo = 42;    # place a reference to 42 in $foo's item container
$foo++;          # deref $foo name, then increment the container's contents to 43
$foo.say;        # deref $foo name, then $foo's container, and call a method on 43.

$foo := 42;      # bind a direct ref to 42
$foo++;          # ERROR, cannot modify immutable value

my @bar = 1,2,3; # deref @bar name to array container, then set its values
@bar»++;         # deref @bar name to array container, then increment each value with a hyper
@bar.say;        # deref @bar name to array container, then call say on that, giving 2 3 4

@bar := (1,2,3); # bind name directly to a Parcel
@bar»++;         # ERROR, parcels are not mutable
