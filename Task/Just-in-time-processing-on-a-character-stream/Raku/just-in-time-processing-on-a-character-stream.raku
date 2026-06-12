#`[
Set srand to set the encode / decode "key".
Need to use the same "key" and same implementation
of Raku to encode / decode. Gain "security" by
exchanging "keys" by a second channel. Default
"key" is "Raku"
]

unit sub MAIN ($key = 'Raku');

srand $key.comb(/<.alnum>/).join.parse-base(36) % 2**63;

my @stream = (flat "\n", ' ' .. '~').roll(*);

sub jit-encode (Str $str) {
    my $i = 0;
    my $last = 0;
    my $enc = '';
    for $str.comb -> $c {
        my $h;
        my $l = '';
        ++$i until $i > 1 && $c eq @stream[$i];
        my $o = $i - $last;
        $l    = $o % 26;
        $h    = $o - $l if $o >= 26;
        $l   += 10;
        $enc ~= ($h ?? $h.base(36).uc !! '') ~ ($l.base(36).lc);
        $last = $i;
    }
    my $block = 60;
    $enc.comb($block).join: "\n"
}

sub jit-decode (Str $str is copy) {
    $str.=subst("\n", '', :g);
    $str ~~ m:g/((.*?) (<:Ll>))/;
    my $dec = '';
    my $i = 0;
    for $/.List -> $l {
        my $o = ($l[0][1].Str.parse-base(36) - 10 // 0) +
                ($l[0][0].Str.parse-base(36) // 0);
        $i += $o;
        $dec ~= @stream[$i];
    }
    $dec
}

my $secret = q:to/END/;
In my opinion, this task is pretty silly.

'Twas brillig, and the slithy toves
    Did gyre and gimble in the wabe.

!@#$%^&*()_+}{[].,><\|/?'";:1234567890
END

say "== Secret: ==\n$secret";

say "\n== Encoded: ==";
say my $enc = jit-encode($secret);

say "\n== Decoded: ==";
say jit-decode($enc);
