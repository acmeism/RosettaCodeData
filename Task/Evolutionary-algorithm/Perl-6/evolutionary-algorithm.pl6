constant target = "METHINKS IT IS LIKE A WEASEL";
constant mutate_chance = .08;
constant alphabet = 'A'..'Z',' ';
constant C = 100;

sub mutate { $^string.comb.map({ rand < mutate_chance ?? alphabet.pick !! $_ }).join }
sub fitness { [+] $^string.comb Zeq state @ = target.comb }

loop (
    my $parent = alphabet.roll(target.chars).join;
    $parent ne target;
    $parent = max :by(&fitness), mutate($parent) xx C
) { printf "%6d: '%s'\n", (state $)++, $parent }
