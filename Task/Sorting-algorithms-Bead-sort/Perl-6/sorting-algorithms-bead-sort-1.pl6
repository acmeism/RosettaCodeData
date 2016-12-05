# routine cribbed from List::Utils;
sub transpose(@list is copy) {
    gather {
        while @list {
            my @heads;
            if @list[0] !~~ Positional { @heads = @list.shift; }
            else { @heads = @list.map({$_.shift unless $_ ~~ []}); }
            @list = @list.map({$_ unless $_ ~~ []});
            take [@heads];
        }
    }
}

sub beadsort(@l) {
    (transpose(transpose(map {[1 xx $_]}, @l))).map(*.elems);
}

my @list = 2,1,3,5;
say beadsort(@list).perl;
