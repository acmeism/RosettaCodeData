sub FloydWarshall{
    my $edges = shift;
    my (@dist, @seq);
    my $num_vert = 0;
    # insert given dists into dist matrix
    map {
        $dist[$_->[0] - 1][$_->[1] - 1] = $_->[2];
        $num_vert = $_->[0] if $num_vert < $_->[0];
        $num_vert = $_->[1] if $num_vert < $_->[1];
    } @$edges;
    my @vertices = 0..($num_vert - 1);
    # init sequence/"next" table
    for my $i(@vertices){
        for my $j(@vertices){
            $seq[$i][$j] = $j if $i != $j;
        }
    }
    # diagonal of dists matrix
    #map {$dist[$_][$_] = 0} @vertices;
    for my $k(@vertices){
        for my $i(@vertices){
            next unless defined $dist[$i][$k];
            for my $j(@vertices){
                next unless defined $dist[$k][$j];
                if($i != $j && (!defined($dist[$i][$j])
                        || $dist[$i][$j] > $dist[$i][$k] + $dist[$k][$j])){
                    $dist[$i][$j] = $dist[$i][$k] + $dist[$k][$j];
                    $seq[$i][$j] = $seq[$i][$k];
                }
            }
        }
    }
    # print table
    print "pair     dist    path\n";
    for my $i(@vertices){
        for my $j(@vertices){
            next if $i == $j;
            my @path = ($i + 1);
            while($seq[$path[-1] - 1][$j] != $j){
                push @path, $seq[$path[-1] - 1][$j] + 1;
            }
            push @path, $j + 1;
            printf "%d -> %d  %4d     %s\n",
                $path[0], $path[-1], $dist[$i][$j], join(' -> ', @path);
        }
    }
}

my $graph = [[1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1]];
FloydWarshall($graph);
