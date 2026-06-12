use v5.36;
use ntheory qw<is_prime lucasu>;

sub abbr ($d,$w) { my $l = length $d; $l < $w+1 ? $d : substr($d,0,$w/2) . '..' . substr($d,-$w/2) . " ($l digits)" }

my($n,$cnt) = (0,0);
do {
    my $f = lucasu(1, -1, $n++);
    my $p = join '', reverse split '', $f;
    printf "%-2d: %s\n", ++$cnt, abbr($p,50) if is_prime $p;
} until $cnt == 25;
