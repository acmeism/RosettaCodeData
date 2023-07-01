my @array = qw "apple orange banana", 4, 42;

scalar @array;      #  5
0 + @arrray;        #  5
'' . @array;        # "5"
my $elems = @array; # $elems = 5

scalar @{  [1,2,3]  }; # [1,2,3] is a reference which is already a scalar

my $array_ref = \@array; # a reference
scalar @$array_ref;


# using subroutine prototypes, not generally recommended
# and not usually what you think they are
sub takes_a_scalar ($) { my ($a) = @_; return $a }

takes_a_scalar @array;

# the built-ins can also act like they have prototypes
