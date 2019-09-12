constant target = "METHINKS IT IS LIKE A WEASEL";
constant mutate_chance = .08;
constant @alphabet = flat 'A'..'Z',' ';
constant C = 100;

sub mutate { [~] (rand < mutate_chance ?? @alphabet.pick !! $_ for $^string.comb) }
sub fitness { [+] $^string.comb Zeq target.comb }

loop (
    my $parent = @alphabet.roll(target.chars).join;
    $parent ne target;
    $parent = max :by(&fitness), mutate($parent) xx C
) { printf "%6d: '%s'\n", $++, $parent }
