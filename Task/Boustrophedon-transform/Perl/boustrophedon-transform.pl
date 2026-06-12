use v5.36; use experimental <builtin for_list>;
use ntheory <factorial lucasu nth_prime vecsum>;
use List::Util 'head';

sub abbr ($d) { my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }

sub boustrophedon_transform (@seq) {
    my @bt;
    my @bx = $seq[0];
    for (my $c = 0; $c < @seq; $c++) {
        @bx = reverse map { vecsum head $_+1, $seq[$c], @bx } 0 .. $c;
        push @bt, $bx[0];
    }
    @bt
}

my $upto = 100; #1000 way too slow
for my($name,$seq) (
    '1 followed by 0\'s A000111', [1, (0) x $upto],
    'All-1\'s           A000667', [   (1) x $upto],
    '(-1)^n             A062162', [1, map { (-1)**$_          } 1..$upto],
    'Primes             A000747', [   map { nth_prime $_      } 1..$upto],
    'Fibbonaccis        A000744', [   map { lucasu(1, -1, $_) } 1..$upto],
    'Factorials         A230960', [1, map { factorial $_      } 1..$upto]
) {
    my @bt = boustrophedon_transform @$seq;
    say "\n$name:\n" . join ' ', @bt[0..14];
    say "100th term: " . abbr $bt[$upto-1];
}
