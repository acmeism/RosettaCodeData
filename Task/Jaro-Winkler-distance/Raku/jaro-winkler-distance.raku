sub jaro-winkler ($s, $t) {

    return 0 if $s eq $t;

    my $s_len = + my @s = $s.comb;
    my $t_len = + my @t = $t.comb;

    my $match_distance = ($s_len max $t_len) div 2 - 1;

    my @s_matches;
    my @t_matches;
    my $matches = 0;

    for ^@s -> $i {

        my $start = 0 max $i - $match_distance;
        my $end = $i + $match_distance min ($t_len - 1);

        for $start .. $end -> $j {
            @t_matches[$j] and next;
            @s[$i] eq @t[$j] or next;
            @s_matches[$i] = 1;
            @t_matches[$j] = 1;
            $matches++;
            last;
        }
    }

    return 1 if $matches == 0;

    my $k              = 0;
    my $transpositions = 0;

    for ^@s -> $i {
        @s_matches[$i] or next;
        until @t_matches[$k] { ++$k }
        @s[$i] eq @t[$k] or ++$transpositions;
        ++$k;
    }

    my $prefix = 0;

    ++$prefix if @s[$_] eq @t[$_] for ^(min 4, $s_len, $t_len);

    my $jaro = ($matches / $s_len + $matches / $t_len +
        (($matches - $transpositions / 2) / $matches)) / 3;

    1 - ($jaro + $prefix * .1 * ( 1 - $jaro) )
}


my @words =  './unixdict.txt'.IO.slurp.words;

for <accomodate definately goverment occured publically recieve seperate untill wich>
   -> $word {

   my %result = @words.race.map: { $_ => jaro-winkler($word, $_) };

   say "\nClosest 5 dictionary words with a Jaro-Winkler distance < .15 from $word:";

   printf "%15s : %0.4f\n", .key, .value for %result.grep({ .value < .15 }).sort({+.value, ~.key}).head(5);
}
