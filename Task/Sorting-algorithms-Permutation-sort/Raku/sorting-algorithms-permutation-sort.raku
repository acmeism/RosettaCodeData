# Lexicographic permuter from "Permutations" task.
sub next_perm ( @a ) {
    my $j = @a.end - 1;
    $j-- while $j >= 1 and [>] @a[ $j, $j+1 ];

    my $aj = @a[$j];
    my $k  = @a.end;
    $k-- while [>] $aj, @a[$k];

    @a[ $j, $k ] .= reverse;

    my Int $r = @a.end;
    my Int $s = $j + 1;
    while $r > $s {
        @a[ $r, $s ] .= reverse;
        $r--;
        $s++;
    }
}

sub permutation_sort ( @a ) {
    my @n = @a.keys;
    my $perm_count = [*] 1 .. +@n; # Factorial
    for ^$perm_count {
        my @permuted_a = @a[ @n ];
        return @permuted_a if [le] @permuted_a;
        next_perm(@n);
    }
}

my @data  = < c b e d a >; # Halfway between abcde and edcba
say 'Input  = ' ~ @data;
say 'Output = ' ~ @data.&permutation_sort;
