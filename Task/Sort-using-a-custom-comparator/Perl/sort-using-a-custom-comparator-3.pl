my @strings = qw/here are some sample strings to be sorted/;
my @sorted = map  { $_->[0] }
             sort { $a->[1] <=> $b->[1] || $a->[2] cmp $b->[2] }
             map  { [ $_, length, lc ] }
             @strings;
