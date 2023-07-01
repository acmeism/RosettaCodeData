my %reduced;
my $digits = 2..4;

for $digits.map: * - 1 -> $exp {
    my $start = sum (0..$exp).map( { 10 ** $_ * ($exp - $_ + 1) });
    my $end   = 10**($exp+1) - sum (^$exp).map( { 10 ** $_ * ($exp - $_) } ) - 1;

    ($start ..^ $end).race(:8degree, :3batch).map: -> $den {
        next if $den.contains: '0';
        next if $den.comb.unique <= $exp;

        for $start ..^ $den -> $num {
            next if $num.contains: '0';
            next if $num.comb.unique <= $exp;

            my $set = ($den.comb.head(* - 1).Set ∩ $num.comb.skip(1).Set);
            next if $set.elems < 1;

            for $set.keys {
                my $ne = $num.trans: $_ => '', :delete;
                my $de = $den.trans: $_ => '', :delete;
                if $ne / $de == $num / $den {
                    print "\b" x 40, "$num/$den:$_ => $ne/$de";
                    %reduced{"$num/$den:$_"} = "$ne/$de";
                }
            }
        }
    }


    print "\b" x 40, ' ' x 40, "\b" x 40;

    my $digit = $exp +1;
    my %d = %reduced.pairs.grep: { .key.chars == ($digit * 2 + 3) };
    say "\n({+%d}) $digit digit reduceable fractions:";
    for 1..9 {
        my $cnt = +%d.pairs.grep( *.key.contains: ":$_" );
        next unless $cnt;
        say "  $cnt with removed $_";
    }
    say "\n  12 Random (or all, if less) $digit digit reduceable fractions:";
    say "    {.key.substr(0, $digit * 2 + 1)} => {.value} removed {.key.substr(* - 1)}"
      for %d.pairs.pick(12).sort;
}
