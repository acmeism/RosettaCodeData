my $list = 1 => 2 => 3 => 4 => 5 => 6 => Mu;

loop (my $l = $list; $l; $l = $l.value) {
    say $l.key;
}
