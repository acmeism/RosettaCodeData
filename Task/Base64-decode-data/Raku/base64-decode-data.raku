my $e64 = '
VG8gZXJyIGlzIGh1bWFuLCBidXQgdG8gcmVhbGx5IGZvdWwgdGhpbmdzIHVwIHlvdSBuZWVkIGEgY2
9tcHV0ZXIuCiAgICAtLSBQYXVsIFIuIEVocmxpY2g=
';

my @base64map = flat 'A' .. 'Z', 'a' .. 'z', ^10, '+', '/';
my %base64 is default(0) = @base64map.pairs.invert;

sub base64-decode-slow ($enc) {
    my $buf = Buf.new;
    for $enc.subst(/\s/, '', :g).comb(4) -> $chunck {
        $buf.append: |(sprintf "%06d%06d%06d%06d", |$chunck.comb.map:
            {%base64{$_}.base(2)}).comb(8).map: {:2($_)};
    }
    $buf
}

say 'Slow:';
say base64-decode-slow($e64).decode('utf8');


# Of course, the above routine is slow and is only for demonstration purposes.
# For real code you should use a module, which is MUCH faster and heavily tested.
say "\nFast:";
use Base64::Native;
say base64-decode($e64).decode('utf8');
