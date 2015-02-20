constant @pascal = [1], -> @p { [0, @p Z+ @p, 0] } ... *;

constant @catalan = gather for 2, 4 ... * -> $ix {
    my @row := @pascal[$ix];
    my $mid = +@row div 2;
    take [-] @row[$mid, $mid+1]
}

.say for @catalan[^20];
