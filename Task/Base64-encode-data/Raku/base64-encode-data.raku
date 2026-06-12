sub MAIN {
    my $buf = slurp("./favicon.ico", :bin);
    say buf-to-Base64($buf);
}

my @base64map = flat 'A' .. 'Z', 'a' .. 'z', ^10, '+', '/';

sub buf-to-Base64($buf) {
    join '', gather for $buf.list -> $a, $b = [], $c = [] {
        my $triplet = ($a +< 16) +| ($b +< 8) +| $c;
        take @base64map[($triplet +> (6 * 3)) +& 0x3F];
        take @base64map[($triplet +> (6 * 2)) +& 0x3F];
        if $c.elems {
            take @base64map[($triplet +> (6 * 1)) +& 0x3F];
            take @base64map[($triplet +> (6 * 0)) +& 0x3F];
        }
        elsif $b.elems {
            take @base64map[($triplet +> (6 * 1)) +& 0x3F];
            take '=';
        }
        else { take '==' }
    }
}
