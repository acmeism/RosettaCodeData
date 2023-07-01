use feature 'say';

@strings = qw/Here are some sample strings to be sorted/;

# with a subroutine:
sub mycmp { length $b <=> length $a || lc $a cmp lc $b }
say join ' ', sort mycmp @strings;

# inline:
say join ' ', sort {length $b <=> length $a || lc $a cmp lc $b} @strings

# for large inputs, can be faster with a 'Schwartzian' transform:
say join ' ', map  { $_->[0] }
             sort { $b->[1] <=> $a->[1] || $a->[2] cmp $b->[2] }
             map  { [ $_, length, lc ] }
             @strings;
