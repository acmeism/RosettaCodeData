my @chars =
  set('a' .. 'z'),
  set('A' .. 'Z'),
  set('0' .. '9'),
  set(<!"#$%&'()*+,-./:;<=>?@[]^_{|}~>.comb);

# bleh. unconfuse syntax highlighter. '"

sub MAIN ( Int :$l = 8, Int :$c = 1, Str :$x = '' ) {
    note 'Password length must be >= 4' and exit if $l < 4;
    note 'Can not generate fewer than 0 passwords' and exit if $c < 0;
    my $chars = [∪] @chars».=&filter;
    note 'Can not exclude an entire required character group' and exit
      if any(@chars».elems) == 0;
    for ^$c {
        my @pswd;
        @pswd.push( @chars[$_].roll ) for ^4;
        @pswd.push( $chars    .roll ) for 4 ..^ $l;
        say [~] @pswd.pick(*);
    }

    sub filter (Set $set) { $set ∖ set($x.comb) }
}

sub USAGE() {
    say qq:to/END/;
    Specify a length:              --l=8 (default 8),
    Specify a count:               --c=1 (default 1),
    Specify characters to exclude: --x=
    (must escape characters significant to the shell)
    E.G.
    {$*PROGRAM-NAME} --l=14 --c=5 --x=0O\\\"\\\'1l\\\|I
    END
}
