use Lingua::EN::Numbers;
sub juggler (Int $n where * > 0) { $n, { $_ +& 1 ?? .³.&isqrt !! .&isqrt } … 1 }

sub isqrt ( \x ) { my ( $X, $q, $r, $t ) =  x, 1, 0 ;
    $q +<= 2 while $q ≤ $X ;
    while $q > 1 {
        $q +>= 2; $t = $X - $r - $q; $r +>= 1;
        if $t ≥ 0 { $X = $t; $r += $q }
    }
    $r
}

say " n  l[n]  i[n]   h[n]";
for 20..39 {
    my @j = .&juggler;
    my $max = @j.max;
    printf "%2s %4d  %4d    %s\n", .&comma, +@j-1, @j.first(* == $max, :k), comma $max;
}

say "\n      n     l[n]   i[n]    d[n]";
( 113, 173, 193, 2183, 11229, 15065, 15845, 30817 ).hyper(:1batch).map: {
    my $start = now;
    my @j = .&juggler;
    my $max = @j.max;
    printf "%10s %4d   %4d %10s   %6.2f seconds\n", .&comma, +@j-1, @j.first(* == $max, :k),
      $max.chars.&comma, (now - $start);
}
