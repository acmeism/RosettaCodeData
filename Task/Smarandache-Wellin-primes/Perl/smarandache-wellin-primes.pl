use v5.36;
use ntheory <is_prime next_prime>;
use Lingua::EN::Numbers::Ordinate 'ordinate';

sub abbr ($d) { my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }

print "Smarandache-Wellen primes:\n";
my($p, $i, $nth, $n) = (0, -1, 0);
do {
    $p  = next_prime($p);
    $n .= $p;
    $i++;
    (++$nth and printf("%s: Index:%5d  Last prime:%6d  S-W: %s\n", ordinate $nth, $i, $p, abbr $n)) if is_prime $n;
} until $nth == 8;

sub derived ($n) {
    my %digits;
    $digits{$_}++ for split '', $n;
    join '', map { $digits{$_} // 0 } 0..9;
}

print "\nSmarandache-Wellen derived primes:\n";
($p, $i, $nth, $n) = (1, -1, 0, '');
do {
    $i++;
    $n .= ($p = next_prime($p));
    ++$nth and printf "%4s: Index:%5d  %s\n", ordinate $nth, $i, derived $n if is_prime derived $n;
} until $nth == 20;
