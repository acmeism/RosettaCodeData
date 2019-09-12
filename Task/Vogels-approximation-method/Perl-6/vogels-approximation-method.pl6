my  %costs =
    :W{:16A, :16B, :13C, :22D, :17E},
    :X{:14A, :14B, :13C, :19D, :15E},
    :Y{:19A, :19B, :20C, :23D, :50E},
    :Z{:50A, :12B, :50C, :15D, :11E};

my %demand = :30A, :20B, :70C, :30D, :60E;
my %supply = :50W, :60X, :50Y, :50Z;

my @cols = %demand.keys.sort;

my %res;
my %g = (|%supply.keys.map: -> $x { $x => [%costs{$x}.sort(*.value)».key]}),
   (|%demand.keys.map: -> $x { $x => [%costs.keys.sort({%costs{$_}{$x}})]});

while (+%g) {
    my @d = %demand.keys.map: -> $x
      {[$x, my $z = %costs{%g{$x}[0]}{$x},%g{$x}[1] ?? %costs{%g{$x}[1]}{$x} - $z !! $z]}

    my @s = %supply.keys.map: -> $x
      {[$x, my $z = %costs{$x}{%g{$x}[0]},%g{$x}[1] ?? %costs{$x}{%g{$x}[1]} - $z !! $z]}

    @d = |@d.grep({ (.[2] == max @d».[2]) }).&min: :by(*.[1]);
    @s = |@s.grep({ (.[2] == max @s».[2]) }).&min: :by(*.[1]);

    my ($t, $f) = @d[2] == @s[2] ?? (@s[1],@d[1]) !! (@d[2],@s[2]);
    my ($d, $s) = $t > $f ?? (@d[0],%g{@d[0]}[0]) !! (%g{@s[0]}[0], @s[0]);

    my $v = %supply{$s} min %demand{$d};

    %res{$s}{$d} += $v;
    %demand{$d} -= $v;

    if (%demand{$d} == 0) {
        %supply.grep( *.value != 0 )».key.map: -> $v
          { %g{$v}.splice((%g{$v}.first: * eq $d, :k),1) };
        %g{$d}:delete;
        %demand{$d}:delete;
    }

    %supply{$s} -= $v;

    if (%supply{$s} == 0) {
        %demand.grep( *.value != 0 )».key.map: -> $v
          { %g{$v}.splice((%g{$v}.first: * eq $s, :k),1) };
        %g{$s}:delete;
        %supply{$s}:delete;
    }
}

say join "\t", flat '', @cols;
my $total;
for %costs.keys.sort -> $g {
    print "$g\t";
    for @cols -> $col {
        print %res{$g}{$col} // '-', "\t";
        $total += (%res{$g}{$col} // 0) * %costs{$g}{$col};
    }
    print "\n";
}
say "\nTotal cost: $total";
