use v5.36;
use bigrat try => 'GMP';

sub f { my $r = 1; $r *= $_ for 1..shift; $r }

say 'Actual value to 100 decimal places:';
say '1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581';

say "\nFirst 1000 terms of ζ(3) truncated to 100 decimal places. (accurate to 6 decimal places):";
my $z3;
$z3 += 1/$_**3 for 1..1000;
say $z3->as_float(101);

say "\nFirst 158 terms of Markov / Apéry representation truncated to 100 decimal places:";
$z3 = 0;
$z3 += (-1)**($_-1) * (f($_)**2 / (f(2*$_) * $_**3)) for 1..158;
$z3 *= 5/2;
say $z3->as_float(101);

say "\nFirst 20 terms of Wedeniwski representation truncated to 100 decimal places:";
$z3 = 0;
$z3 += (-1)**$_ *  f(2*$_+1)**3 * f(2*$_)**3 * f($_)**3 * (126392*$_**5 + 412708*$_**4 + 531578*$_**3 + 336367*$_**2 + 104000*$_ + 12463)
                 / ( f(3*$_+2) * f(4*$_+3)**3 )
       for 0..19;
$z3 *= 1/24;
say $z3->as_float(101);
