my $b = 99;

repeat while --$b {
    say "{b $b} on the wall";
    say "{b $b}";
    say "Take one down, pass it around";
    say "{b $b-1} on the wall";
    say "";
}

sub b($b) {
    "$b bottle{'s' if $b != 1} of beer";
}
