my \N = 2200;
my @sq = (0 .. N)»²;
my @not = False xx N;
@not[0] = True;

(1 .. N).race.map: -> $d {
    my $last = 0;
    for $d ... ($d/3).ceiling -> $a {
        for 1 .. ($a/2).ceiling -> $b {
            last if (my $ab = @sq[$a] + @sq[$b]) > @sq[$d];
            if (@sq[$d] - $ab).sqrt.narrow ~~ Int {
                @not[$d] = True;
                $last = 1;
                last
            }
        }
        last if $last;
    }
}

say @not.grep( *.not, :k );
