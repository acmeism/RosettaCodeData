sub count_jewels {
    my( $j, $s ) = @_;
    my($c,%S);

    $S{$_}++     for split //, $s;
    $c += $S{$_} for split //, $j;
    return "$c\n";
}

print count_jewels 'aA' , 'aAAbbbb';
print count_jewels 'z'  , 'ZZ';
