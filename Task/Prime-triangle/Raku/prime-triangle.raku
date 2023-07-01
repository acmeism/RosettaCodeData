my @count = 0, 0, 1;
my $lock = Lock.new;
put (1,2);

for 3..17 -> $n {
    my @even = (2..^$n).grep: * %% 2;
    my @odd  = (3..^$n).grep: so * % 2;
    @even.permutations.race.map: -> @e {
        quietly next if @e[0] == 8|14;
        my $nope = 0;
        for @odd.permutations -> @o {
            quietly next unless (@e[0] + @o[0]).is-prime;
            my @list;
            for (@list = (flat (roundrobin(@e, @o)), $n)).rotor(2 => -1) {
                $nope++ and last unless .sum.is-prime;
            }
            unless $nope {
                put '1 ', @list unless @count[$n];
                $lock.protect({ @count[$n]++ });
            }
            $nope = 0;
        }
    }
}
put "\n", @count[2..*];
