my @left;
my @right;

sub reset {
    @left  = <HXUCZVAMDSLKPEFJRIGTWOBNYQ>.comb;
    @right = <PTLNBQDEOYSFAVZKGJRIHWXUMC>.comb;
}

sub encode ($letter) {
    my $index = @right.first: $letter.uc, :k;
    my $enc   = @left[$index];
    $index.&permute;
    $enc
}

sub decode ($letter) {
    my $index = @left.first: $letter.uc, :k;
    my $dec   = @right[$index];
    $index.&permute;
    $dec
}

sub permute ($index) {
    @left.=rotate: $index;
    @left[1..13].=rotate;
    @right.=rotate: $index + 1;
    @right[2..13].=rotate;
}

reset;
say 'WELLDONEISBETTERTHANWELLSAID'.comb».&encode.join;
reset;
say 'OAHQHCNYNXTSZJRRHJBYHQKSOUJY'.comb».&decode.join;
