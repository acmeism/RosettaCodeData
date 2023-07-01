sub Floyd-Warshall (Int $n, @edge) {
    my @dist = [0, |(Inf xx $n-1)], *.Array.rotate(-1) … !*[*-1];
    my @next = [0 xx $n] xx $n;

    for @edge -> ($u, $v, $w) {
        @dist[$u-1;$v-1] = $w;
        @next[$u-1;$v-1] = $v-1;
    }

    for [X] ^$n xx 3 -> ($k, $i, $j) {
        if @dist[$i;$j] > my $sum = @dist[$i;$k] + @dist[$k;$j] {
            @dist[$i;$j] = $sum;
            @next[$i;$j] = @next[$i;$k];
        }
    }

    say ' Pair  Distance     Path';
    for [X] ^$n xx 2 -> ($i, $j){
        next if $i == $j;
        my @path = $i;
        @path.push: @next[@path[*-1];$j] until @path[*-1] == $j;
        printf("%d → %d  %4d       %s\n", $i+1, $j+1, @dist[$i;$j],
          @path.map( *+1 ).join(' → '));
    }
}

Floyd-Warshall(4, [[1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1]]);
