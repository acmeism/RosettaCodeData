constant palindromes = 0, 1, |gather for 1 .. * -> $p {
    my $pal = $p.base(3);
    my $n = :3($pal ~ '1' ~ $pal.flip);
    next if $n %% 2;
    my $b2 = $n.base(2);
    next if $b2.chars %% 2;
    next unless $b2 eq $b2.flip;
    take $n;
}

printf "%d, %s, %s\n", $_, .base(2), .base(3) for palindromes[^6];
