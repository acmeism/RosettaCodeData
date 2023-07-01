sub fairshare (\b) { ^∞ .hyper.map: { .polymod( b xx * ).sum % b } }

.say for <2 3 5 11>.map: { .fmt('%2d:') ~ .&fairshare[^25]».fmt('%2d').join: ', ' }

say "\nRelative fairness of this method. Scaled fairness correlation. The closer to 1.0 each person
is, the more fair the selection algorithm is. Gets better with more iterations.";

for <2 3 5 11 39> -> $people {
    print "\n$people people: \n";
    for $people * 1, $people * 10, $people * 1000 -> $iterations {
        my @fairness;
        fairshare($people)[^$iterations].kv.map: { @fairness[$^v % $people] += $^k }
        my $scale = @fairness.sum / @fairness;
        my @range = @fairness.map( { $_ / $scale } );
        printf "After round %4d: Best advantage: %-10.8g - Worst disadvantage: %-10.8g - Spread between best and worst: %-10.8g\n",
            $iterations/$people, @range.min, @range.max, @range.max - @range.min;
    }
}
