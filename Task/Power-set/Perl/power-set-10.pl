my @set = (1, 2, 3);
my @powerset = powerset(@set);

sub set_to_string {
    "{" . join(", ", map { ref $_ ? set_to_string(@$_) : $_ } @_) . "}"
}

print set_to_string(@powerset), "\n";
