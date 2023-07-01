# Given sequence definitions
#   start  stop  inc.   Comment
for   -2,    2,    1, # Normal
      -2,    2,    0, # Zero increment
      -2,    2,   -1, # Increments away from stop value
      -2,    2,   10, # First increment is beyond stop value
       2,   -2,    1, # Start more than stop: positive increment
       2,    2,    1, # Start equal stop: positive increment
       2,    2,   -1, # Start equal stop: negative increment
       2,    2,    0, # Start equal stop: zero increment
       0,    0,    0, # Start equal stop equal zero: zero increment

# Additional "problematic" sequences
       1,  Inf,    3, # Endpoint literally at infinity
       0,    π,  τ/8, # Floating point numbers
     1.4,    *, -7.1  # Whatever

  -> $start, $stop, $inc {
    my $seq = flat ($start, *+$inc … $stop);
    printf "Start: %3s, Stop: %3s, Increment: %3s | ", $start, $stop.Str, $inc;
    # only show up to the first 15 elements of possibly infinite sequences
    put $seq[^15].grep: +*.defined
}

# For that matter the start and end values don't need to be numeric either. Both
# or either can be a function, list, or other object. Really anything that a
# "successor" function can be defined for and produces a value.
say "\nDemonstration of some other specialized sequence operator functionality:";
# Start with a list, iterate by multiplying the previous 3 terms together
# and end with a term defined by a function.
put 1, -.5, 2.sqrt, * × * × * … *.abs < 1e-2;

# Start with an array, iterate by rotating, end when 0 is in the last place.
say [0,1,2,3,4,5], *.rotate(-1).Array … !*.tail;

# Iterate strings backwards.
put 'xp' … 'xf';
