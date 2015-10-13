sub balanced($_ is copy) {
    () while s:g/'[]'//;
    $_ eq '';
}

my $n = prompt "Number of bracket pairs: ";
my $s = <[ ]>.roll($n*2).join;
say "$s is", ' not' x not balanced($s), " well-balanced";
