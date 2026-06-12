sub shuffle ($n, $limit) {
     next if $n %% 10;
     my $sorted = +$n.comb.sort(-*).join;
     my @sg = $n;
     for 2..9 {
        my $multiple = $n * $_;
        last if $multiple > $limit;
        if +$multiple.comb.sort(-*).join == $sorted { @sg.push: $_ }
     }
     @sg if +@sg > 1;
}

my @shuffle-groups = lazy (3..*).map: -> $e {
     my $l = 10**($e+1);
    |(10**$e .. 5*10**$e).hyper(:5000batch).map: {shuffle $_, $l};
}

say "First twenty shuffle groups\n index  group";
printf "%6d %s\n", $++, .gist for @shuffle-groups[^20];

display(|$_) for (
    'more than 4', {+$_ >  4},
    'exactly 3',   {+$_ == 4},
    'exactly 4',   {+$_ == 5}
).batch: 2;

sub display ($msg, &filter) {
    my $start = now;
    my ($key, $value) = @shuffle-groups.first( &filter, :kv );
    say "\nFirst shuffle group with $msg witnesses\n index  group";
    printf "%6d %s\n", $key, $value.gist;
    say "\nFor the first {$key+1} shuffle groups, there are:";
    printf "%5d with %d witness%s\n", +.value, .key-1, (.key - 1) > 1 ?? 'es' !! ''
    for @shuffle-groups[0..$key].classify(+*).sort: -*.key;
    printf "%.3f seconds\n", now - $start;
}
