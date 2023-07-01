my @scores =
    Solomon => 44,
    Jason   => 42,
    Errol   => 42,
    Garry   => 41,
    Bernard => 41,
    Barry   => 41,
    Stephen => 39;

sub tiers (@s) { @s.classify(*.value).pairs.sort.reverse.map: { .value».key } }

sub standard (@s) {
    my $rank = 1;
    gather for tiers @s -> @players {
	take $rank => @players;
	$rank += @players;
    }
}

sub modified (@s) {
    my $rank = 0;
    gather for tiers @s -> @players {
	$rank += @players;
	take $rank => @players;
    }
}

sub dense (@s) { tiers(@s).map: { ++$_ => @^players } }

sub ordinal (@s) { @s.map: ++$_ => *.key }

sub fractional (@s) {
    my $rank = 1;
    gather for tiers @s -> @players {
	my $beg = $rank;
	my $end = $rank += @players;
	take [+]($beg ..^ $end) / @players => @players;
    }
}

say   "Standard:";   .perl.say for   standard @scores;
say "\nModified:";   .perl.say for   modified @scores;
say "\nDense:";      .perl.say for      dense @scores;
say "\nOrdinal:";    .perl.say for    ordinal @scores;
say "\nFractional:"; .perl.say for fractional @scores;
