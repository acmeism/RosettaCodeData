my $a = [["a", "b", "c"], ["", "q", "z"], ["zap", "zip", "Zot"]];
foreach (@{sorttable $a, column => 1, reverse => 1})
   {foreach (@$_)
       {printf "%-5s", $_;}
    print "\n";}
