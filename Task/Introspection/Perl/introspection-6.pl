use 5.010;
our $bloop = -12;
if (defined $::bloop) {
    if (eval { abs(1) }) {
        say 'abs($bloop) is ' . abs($::bloop);
    }
    else {
        say 'abs() is not available';
    }
}
else {
    say '$bloop is not defined';
}
