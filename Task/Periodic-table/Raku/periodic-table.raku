my $b = 18;
my @offset = 16, 10, 10, (2×$b)+1, (-2×$b)-15, (2×$b)+1, (-2×$b)-15;
my @span   = flat ^8 Zxx <1 3 8 44 15 17 15 15>;

for <1 2 29 42 57 58 72 89 90 103> -> $n {
    printf "%3d: %2d, %2d\n", $n, map {$_+1}, ($n-1 + [+] @offset.head(@span[$n-1])).polymod($b).reverse;
}
