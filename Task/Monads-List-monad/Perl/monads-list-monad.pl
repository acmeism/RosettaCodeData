use strict;
use feature 'say';
use Data::Monad::List;

# Cartesian product to 'count' in binary
my @cartesian = [(
    list_flat_map_multi { scalar_list(join '', @_) }
        scalar_list(0..1),
        scalar_list(0..1),
        scalar_list(0..1)
)->scalars];
say join "\n", @{shift @cartesian};

say '';

# Pythagorean triples
my @triples = [(
    list_flat_map_multi { scalar_list(
            { $_[0] < $_[1] && $_[0]**2+$_[1]**2 == $_[2]**2 ? join(',',@_) : () }
        ) }
        scalar_list(1..10),
        scalar_list(1..10),
        scalar_list(1..10)
)->scalars];

for (@{shift @triples}) {
    say keys %$_ if keys %$_;
}
