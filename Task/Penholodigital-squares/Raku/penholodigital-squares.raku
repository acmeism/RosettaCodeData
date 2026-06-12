use Prime::Factor;

(9 .. 12).map: -> $base {
    my $test = (1 ..^ $base)».base($base).join;
    my $skip = ($base - 1).&prime-factors.tail;
    my $start = $test     .parse-base($base).sqrt.Int div $skip;
    my $end   = $test.flip.parse-base($base).sqrt.Int div $skip;
    say "\nThere is a total of {+$_} penholodigital squares in base $base:\n" ~
        .map({"{.base($base)}² = {.².base($base)}"}).batch(3)».join(", ").join: "\n" given
        cache ($start .. $end).map({$_ * $skip}).hyper.map: { next unless .².base($base).comb.sort.join eq $test; $_ }
}

(13 .. 16).map: -> $base {
    my $test = (1 ..^ $base)».base($base).join;
    my $skip = ($base - 1).&prime-factors.tail;
    my $start = $test     .parse-base($base).sqrt.Int div $skip;
    my $end   = $test.flip.parse-base($base).sqrt.Int div $skip;
    my @penholo = ($start .. $end).map({$_ * $skip}).hyper.map: { next unless .².base($base).comb.sort.join eq $test; $_ }
    say "\nThere is a total of {+@penholo} penholodigital squares in base $base:";
    say @penholo[0,*-1].map({"{.base($base)}² = {.².base($base)}"}).batch(3)».join(", ").join: "\n" if +@penholo;
}
