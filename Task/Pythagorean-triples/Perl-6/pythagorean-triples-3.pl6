sub triples($limit) {
    my $primitive = 0;
    my $civilized = 0;

    sub oyako($a, $b, $c) {
        my $perim = $a + $b + $c;
        return if $perim > $limit;
    ++$primitive; $civilized += $limit div $perim;
        oyako( $a - 2*$b + 2*$c,  2*$a - $b + 2*$c,  2*$a - 2*$b + 3*$c);
        oyako( $a + 2*$b + 2*$c,  2*$a + $b + 2*$c,  2*$a + 2*$b + 3*$c);
        oyako(-$a + 2*$b + 2*$c, -2*$a + $b + 2*$c, -2*$a + 2*$b + 3*$c);
    }

    oyako(3,4,5);
    "$limit => ($primitive $civilized)";
}

for 10,100,1000 ... * -> $limit {
    say triples $limit;
}
