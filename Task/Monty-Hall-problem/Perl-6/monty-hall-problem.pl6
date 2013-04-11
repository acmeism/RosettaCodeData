sub remove (@a is rw, Int $i) {
    my $temp = @a[$i];
    @a = @a[0 ..^ $i], @a[$i ^..^ @a];
    return $temp;
}

enum Prize <Car Goat>;
enum Strategy <Stay Switch>;

sub play (Strategy $strategy, Int :$doors = 3) returns Prize {
    # Call the door with a car behind it door 0. Number the
    # remaining doors starting from 1.
    my Prize @doors = Car, Goat xx $doors - 1;
    # The player chooses a door.
    my Prize $initial_pick = remove @doors, @doors.keys().pick;
    # Of the n doors remaining, the host chooses n - 1 that have
    # goats behind them and opens them, removing them from play.
    remove @doors, $_
        for pick @doors.elems - 1, grep { @doors[$_] == Goat }, keys @doors;
    # If the player stays, they get their initial pick. Otherwise,
    # they get whatever's behind the remaining door.
    return $strategy == Stay ?? $initial_pick !! @doors[0];
}

constant TRIALS = 100;

for 3, 10 -> $doors {
    my %wins;
    say "With $doors doors: ";
    for Stay, 'Staying', Switch, 'Switching' -> $s, $name {
        for ^TRIALS {
            ++%wins{$s} if play($s, doors => $doors) == Car;
        }
        say "  $name wins ",
            round(100*%wins{$s} / TRIALS),
            '% of the time.'
    }
}
