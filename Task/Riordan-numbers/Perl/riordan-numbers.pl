use v5.36;
use bigint try => 'GMP';
use experimental <builtin for_list>;
use List::Util 'max';
use List::Lazy 'lazy_list';
use Lingua::EN::Numbers qw(num2en_ordinal);

sub abbr ($d) { my $l = length $d; $l < 41 ? $d : substr($d,0,20) . '..' . substr($d,-20) . " ($l digits)" }
sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }
sub table ($c, @V) { my $t = $c * (my $w = 2 + max map { length } @V); ( sprintf( ('%'.$w.'s')x@V, @V) ) =~ s/.{1,$t}\K/\n/gr }

my @riordan;
my $riordan_lazy = lazy_list { state @r = (1,0); state $n = 1; $n++; push @r, ($n-1) * (2*$r[1] + 3*$r[0]) / ($n+1) ; shift @r };
push @riordan, $riordan_lazy->next() for 1..1e4;

say 'First thirty-two Riordan numbers:';
say table 4, map { comma $_ } @riordan[0..31];
say 'The ' . num2en_ordinal($_) . ': ' . abbr $riordan[$_ - 1] for 1e3, 1e4;
