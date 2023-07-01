use feature 'say';

# Perl arrays are internally always one-dimensional, but multi-dimension arrays are supported via references.
# So a two-dimensional array is an arrays-of-arrays, (with 'rows' that are references to arrays), while a
# three-dimensional array is an array of arrays-of-arrays, and so on. There are no arbitrary limits on the
# sizes or number of dimensions (i.e. the 'depth' of nesting references).

# To generate a zero-initialized 2x3x4x5 array
for $i (0..1) {
  for $j (0..2) {
    for $k (0..3) {
      $a[$i][$j][$k][$l] = [(0)x5];
    }
  }
}

# There is no requirement that the overall shape of array be regular, or that contents of
# the array elements be of the the same type.  Arrays can contain almost any type of values
@b = (
     [1, 2, 4, 8, 16, 32],                                                      # numbers
     [<Mon Tue Wed Thu Fri Sat Sun>],                                           # strings
     [sub{$_[0]+$_[1]}, sub{$_[0]-$_[1]}, sub{$_[0]*$_[1]}, sub{$_[0]/$_[1]}]   # coderefs
);
say $b[0][5];           # prints '32'
say $b[1][2];           # prints 'Wed'
say $b[2][0]->(40,2);   # prints '42', sum of 40 and 2

# Pre-allocation is possible, can result in a more efficient memory layout
# (in general though Perl allows minimal control over memory)
$#$big = 1_000_000;

# But dimensions do not need to be pre-declared or pre-allocated.
# Perl will auto-vivify the necessary storage slots on first access.
$c[2][2] = 42;
# @c =
#    [undef]
#    [undef]
#    [undef, undef, 42]

# Negative indicies to count backwards from the end of each dimension
say $c[-1][-1]; # prints '42'

# Elements of an array can be set one-at-a-time or in groups via slices
my @d = <Mon Tue Ned Sat Fri Thu>;
push @d, 'Sun';
$d[2] = 'Wed';
@d[3..5] = @d[reverse 3..5];
say "@d"; # prints 'Mon Tue Wed Thu Fri Sat Sun'
