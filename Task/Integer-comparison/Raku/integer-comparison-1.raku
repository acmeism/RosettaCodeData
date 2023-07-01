my $a = prompt("1st int: ").floor;
my $b = prompt("2nd int: ").floor;

if $a < $b {
    say 'Less';
}
elsif $a > $b {
    say 'Greater';
}
elsif $a == $b {
    say 'Equal';
}
