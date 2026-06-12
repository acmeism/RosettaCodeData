use v5.36;
no warnings 'recursion';
use ntheory 'is_prime';

sub condense($n) { $n =~ /^((.)\2+)/; my $i = length $1; $i>9 ? "($2 x $i) " . substr($n,$i) : $n }

sub combine ($d, $a, $b, $s='') {                      # NB: $a < $b
       if ($d==1 && is_prime $s.$a) { return $s.$a }
    elsif ($d==1 && is_prime $s.$b) { return $s.$b }
    elsif ($d==1                  ) { return 0     }
    else                            { return combine($d-1,$a,$b,$s.$a) || combine($d-1,$a,$b,$s.$b) }
}

my($a,$b) = (1,2);
say "Smallest n digit prime using only $a and $b (or '0' if none exists):";
printf "%4d: %s\n", $_,          combine($_,$a,$b) for             1..20;
printf "%4d: %s\n", $_, condense combine($_,$a,$b) for map 100*$_, 1..20;

($a,$b)   = (7,9);
say "\nSmallest n digit prime using only $a and $b (or '0' if none exists):";
printf "%4d: %s\n", $_, condense combine($_,$a,$b) for 1..20, 100, 200;

# 1st term missing
#($a,$b) = (0,1);
#printf "%4d: %s\n", $_+1, combine($_,$a,$b,1) for 1..19;

