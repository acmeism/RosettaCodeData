use 5.10.0;  # for '++' non-backtrack behavior
sub balanced {
        my $_ = shift;
        s/(\[(?:[^\[\]]++|(?1))*\])//g;
        ! /[\[\]]/;
}

for (']', '[', '[[]', '][]', '[[]]', '[[]]]][][]]', 'x[ y [ [] z ]][ 1 ][]abcd') {
        print balanced($_) ? "" : "not ", "balanced:\t'$_'\n";
}
