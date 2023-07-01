use List::Util 1.33 qw(all);

all { $strings[0] eq $strings[$_] } 1..$#strings  # All equal
all { $strings[$_-1] lt $strings[$_] } 1..$#strings  # Strictly ascending
