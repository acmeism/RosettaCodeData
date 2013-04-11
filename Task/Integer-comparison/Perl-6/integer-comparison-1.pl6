my Int $a = floor $*IN.get;
my Int $b = floor $*IN.get;

if $a < $b {
    say 'Less';
}
elsif $a > $b {
    say 'Greater';
}
elsif $a == $b {
    say 'Equal';
}
