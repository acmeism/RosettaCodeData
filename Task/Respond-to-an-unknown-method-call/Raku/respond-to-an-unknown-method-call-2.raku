class L-Value {
    our $.value = 10;
    method FALLBACK($name, |c) is rw { $.value }
}

my $l = L-Value.new;
say $l.any-odd-name; # 10
$l.some-other-name = 42;
say $l.i-dont-know; # 42
