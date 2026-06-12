use Algorithm::Combinatorics qw/tuples_with_repetition/;
print join(" ", map { "[@$_]" } tuples_with_repetition([qw/A B C/],2)), "\n";
