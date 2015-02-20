sub MAIN ($square = 4) {
    say "{$square}? Seriously?" and exit if $square < 1 or $square > 26;
    my %bits = map { $_ => %( map { $_ => 0 }, ('A' .. *)[^ $square] ) },
        (1 .. *)[^ $square];
    scramble %bits;
    my $target = build %bits;
    scramble %bits until build(%bits) ne $target;
    display($target, %bits);
    my $turns = 0;
    while my $flip = prompt "Turn {++$turns}: Flip which row / column? " {
        flip $flip.match(/\w/).uc, %bits;
        if display($target, %bits) {
            say "Hurray! You solved it in $turns turns.";
            last;
        }
    }
}

sub display($goal, %hash) {
    shell('clear');
    say "Goal\n$goal\nYou";
    my $this = build %hash;
    say $this;
    return ($goal eq $this);
}

sub flip ($a, %hash) {
    given $a {
        when any(keys %hash) {
            %hash{$a}{$_} = %hash{$a}{$_} +^ 1 for %hash{$a}.keys
        };
        when any(keys %hash{'1'}) {
            %hash{$_}{$a} = %hash{$_}{$a} +^ 1 for %hash.keys
        };
    }
}

sub build (%hash) {
    my $string = '   ';
    $string ~= sprintf "%2s ", $_ for sort keys %hash{'1'};
    $string ~= "\n";
    for sort keys %hash -> $key {
        $string ~= sprintf "%2s ", $key;
        $string ~= sprintf "%2s ", %hash{$key}{$_} for sort keys %hash{$key};
        $string ~=  "\n";
    };
    $string
}

sub scramble(%hash) {
    my @keys = keys %hash;
    @keys ,= keys %hash{'1'};
    flip $_,  %hash for @keys.pick( @keys/2 );
}
