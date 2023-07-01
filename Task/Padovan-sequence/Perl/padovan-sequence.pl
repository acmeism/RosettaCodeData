use strict;
use warnings;
use feature <state say>;
use List::Lazy 'lazy_list';

my $p = 1.32471795724474602596;
my $s = 1.0453567932525329623;
my %rules = (A => 'B', B => 'C', C => 'AB');

my $pad_recur = lazy_list { state @p = (1, 1, 1, 2); push @p, $p[1]+$p[2]; shift @p };

sub pad_floor { int 1/2 + $p**($_<3 ? 1 : $_-2) / $s }

my($l, $m, $n) = (10, 20, 32);

my(@pr, @pf);
push @pr, $pad_recur->next() for 1 .. $n; say join ' ', @pr[0 .. $m-1];
push @pf,  pad_floor($_)     for 1 .. $n; say join ' ', @pf[0 .. $m-1];

my @L = 'A';
push @L, join '', @rules{split '', $L[-1]} for 1 .. $n;
say join ' ', @L[0 .. $l-1];

$pr[$_] == $pf[$_] and $pr[$_] == length $L[$_] or die "Uh oh, n=$_: $pr[$_] vs $pf[$_] vs " . length $L[$_] for 0 .. $n-1;
say '100% agreement among all 3 methods.';
