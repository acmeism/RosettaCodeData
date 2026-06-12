use Sort::Naturally;

sub getpal ($str) {
    my @chars = $str.comb;
    my @pal = flat @chars,
    (1 ..^ @chars).map: -> \idx {
        my @s;
        for 1, 2 {
           my int ($rev, $fwd) = $_, 1;
           loop {
                quietly last if ($rev > idx) || (@chars[idx - $rev] ne @chars[idx + $fwd]);
                $rev = $rev + 1;
                $fwd = $fwd + 1;
            }
            @s.push: @chars[idx - $rev ^..^ idx + $fwd].join if $rev + $fwd > 2;
            last if @chars[idx - 1] ne @chars[idx];
        }
        next unless +@s;
        @s
    }
    @pal.unique.sort({.chars, .&naturally});
}

say 'All palindromic substrings including (bizarrely enough) single characters:';
put "$_ => ", getpal $_ for 100..125;
put "\nDo these strings contain a minimum two character palindrome?";
printf "%25s => %s\n", $_, getpal($_).tail.chars > 1 for flat
    9, 169, 12769, 1238769, 123498769, 12346098769, 1234572098769,
    123456832098769, 12345679432098769, 1234567905432098769,
    123456790165432098769, 83071934127905179083, 1320267947849490361205695,
    <Do these strings contain a minimum two character palindrome?>
