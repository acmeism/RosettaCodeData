sub mycmp { length $b <=> length $a || lc $a cmp lc $b }

my @strings = ("Here", "are", "some", "sample", "strings", "to", "be", "sorted");
my @sorted = sort mycmp @strings;
