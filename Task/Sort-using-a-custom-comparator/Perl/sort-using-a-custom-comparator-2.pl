my @strings = qw/here are some sample strings to be sorted/;
my @sorted = sort {length $b <=> length $a || lc $a cmp lc $b} @strings
