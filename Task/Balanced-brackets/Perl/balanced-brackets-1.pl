use 5.10.0;  # for given ... when construct
sub balanced {
        my $depth = 0;
        for (split //, shift) {
            when('[') { ++$depth }
            when(']') { return if --$depth < 0 }
        }
        return !$depth
}

for (']', '[', '[[]', '][]', '[[]]', '[[]]]][][]]', 'x[ y [ [] z ]][ 1 ][]abcd') {
        print balanced($_) ? "" : "not ", "balanced:\t'$_'\n";
}
