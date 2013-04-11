my @vampires := gather for 1 .. * -> $start, $end {
    map {
        my @fangs = is_vampire($_);
        take "$_: { @fangs.join(', ') }" if @fangs.elems
    }, 10 ** $start .. 10 ** $end
}

say "\nFirst 25 Vampire Numbers:\n";

.say for @vampires[^25];

say "\nIndividual tests:\n";

for 16758243290880, 24959017348650, 14593825548650 {
    print "$_: ";
    my @fangs = is_vampire($_);
    if @fangs.elems {
         say @fangs.join(', ');
    } else {
         say 'is not a vampire number.';
    }
}

sub is_vampire (Int $num) {
    my $digits = $num.comb.sort;
    my @fangs;
    for vfactors($num) -> $this {
        my $that = $num div $this;
        @fangs.push("$this x $that") if
            !($this %% 10 && $that %% 10) and
            ($this ~ $that).comb.sort eq $digits;
    }
    return @fangs;
}

sub vfactors (Int $n) {
   map { $_ if $n %% $_ }, 10**$n.sqrt.log(10).floor .. $n.sqrt.ceiling;
}
