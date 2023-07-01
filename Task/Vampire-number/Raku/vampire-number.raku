sub is_vampire (Int $num) {
    my $digits = $num.comb.sort;
    my @fangs;
    (10**$num.sqrt.log(10).floor .. $num.sqrt.ceiling).map: -> $this {
        next if $num % $this;
        my $that = $num div $this;
        next if $this %% 10 && $that %% 10;
        @fangs.push("$this x $that") if ($this ~ $that).comb.sort eq $digits;
    }
    @fangs
}

constant @vampires = flat (3..*).map: -> $s, $e {
    (10**$s .. 10**$e).hyper.map: -> $n {
        next unless my @fangs = is_vampire($n);
        "$n: { @fangs.join(', ') }"
    }
}

say "\nFirst 25 Vampire Numbers:\n";

.say for @vampires[^25];

say "\nIndividual tests:\n";

.say for (16758243290880, 24959017348650, 14593825548650).hyper(:1batch).map: {
    "$_: " ~ (is_vampire($_).join(', ') || 'is not a vampire number.')
}
