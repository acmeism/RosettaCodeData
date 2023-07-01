sub sleeping-beauty ($trials) {
    my $gotheadsonwaking = 0;
    my $wakenings = 0;
    ^$trials .map: {
        given <Heads Tails>.roll {
            ++$wakenings;
            when 'Heads' { ++$gotheadsonwaking }
            when 'Tails' { ++$wakenings }
        }
    }
    say "Wakenings over $trials experiments: ", $wakenings;
    $gotheadsonwaking / $wakenings
}

say "Results of experiment:  Sleeping Beauty should estimate a credence of: ", sleeping-beauty(1_000_000);
