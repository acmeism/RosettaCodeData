my $b = 99;

sub b($b) {
    "$b bottle{'s'.substr($b == 1)} of beer";
}

repeat while --$b {
    .say for "&b($b) on the wall",
             b($b),
             'Take one down, pass it around',
             "&b($b-1) on the wall",
             '';
}
