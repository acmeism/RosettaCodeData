use Prime::Factor;

sub is_vampire (Int $num) {
    return Empty unless $num % 9 == 0|4;
    my $digits = $num.comb.sort;
    my @fangs;
    my @divs = $num.&divisors(:s).grep({.chars == $num.chars div 2});
    return Empty unless @divs >= 2;
    @divs.map: -> $this {
         my $that = $num div $this;
         next if $this %% 10 && $that %% 10;
         last if $this > $that;
         @fangs.push("$this x $that") if ($this ~ $that).comb.sort eq $digits;
    }
    @fangs
}

constant @vampires = flat (3..*).map: -> $s, $e {
    (flat (10**$s div 9 .. 10**$e div 9).map({my $v = $_ * 9, $v + 4})).hyper.map: -> $n {
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
