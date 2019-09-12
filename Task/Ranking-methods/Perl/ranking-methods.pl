my %scores = (
    'Solomon' => 44,
    'Jason'   => 42,
    'Errol'   => 42,
    'Garry'   => 41,
    'Bernard' => 41,
    'Barry'   => 41,
    'Stephen' => 39
);

sub tiers {
    my(%s) = @_; my(%h);
    push @{$h{$s{$_}}}, $_ for keys %s;
    @{\%h}{reverse sort keys %h};
}

sub standard {
    my(%s) = @_; my($result);
    my $rank = 1;
    for my $players (tiers %s) {
        $result .= "$rank " . join(', ', sort @$players) . "\n";
        $rank += @$players;
    }
    return $result;
}

sub modified {
    my(%s) = @_; my($result);
    my $rank = 0;
    for my $players (tiers %s) {
        $rank += @$players;
        $result .= "$rank " . join(', ', sort @$players) . "\n";
    }
    return $result;
}

sub dense {
    my(%s) = @_; my($n,$result);
    $result .= sprintf "%d %s\n", ++$n, join(', ', sort @$_) for tiers %s;
    return $result;
}

sub ordinal {
    my(%s) = @_; my($n,$result);
    for my $players (tiers %s) {
        $result .= sprintf "%d %s\n", ++$n, $_ for sort @$players;
    }
    return $result;
}

sub fractional {
    my(%s) = @_; my($result);
    my $rank = 1;
    for my $players (tiers %s) {
        my $beg = $rank;
        my $end = $rank += @$players;
        my $avg = 0;
        $avg += $_/@$players for $beg .. $end-1;
        $result .= sprintf "%3.1f %s\n", $avg, join ', ', sort @$players;
    }
    return $result;
}

print "Standard:\n"    .   standard(%scores) . "\n";
print "Modified:\n"    .   modified(%scores) . "\n";
print "Dense:\n"       .      dense(%scores) . "\n";
print "Ordinal:\n"     .    ordinal(%scores) . "\n";
print "Fractional:\n"  . fractional(%scores) . "\n";
