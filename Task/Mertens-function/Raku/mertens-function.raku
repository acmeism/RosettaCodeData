use Prime::Factor;

sub μ (Int \n) {
    return 0 if n %% 4 or n %% 9 or n %% 25 or n %% 49 or n %% 121;
    my @p = prime-factors(n);
    +@p == +@p.unique ?? +@p %% 2 ?? 1 !! -1 !! 0
}

my @mertens = lazy [\+] flat '', 1, (2..*).hyper.map: -> \n { μ(n) };

put "Mertens sequence - First 199 terms:\n",
    @mertens[^200]».fmt('%3s').batch(20).join("\n"),
    "\n\nEquals zero ", +@mertens[1..1000].grep( !* ),
    ' times between 1 and 1000', "\n\nCrosses zero ",
    +@mertens[1..1000].kv.grep( {!$^v and @mertens[$^k]} ),
    " times between 1 and 1000\n\nFirst Mertens equal to:";

for 10, 20, 30 … 100 -> $threshold {
    printf "%4d: M(%d)\n", -$threshold, @mertens.first: * == -$threshold, :k;
    printf "%4d: M(%d)\n",  $threshold, @mertens.first: * ==  $threshold, :k;
}
