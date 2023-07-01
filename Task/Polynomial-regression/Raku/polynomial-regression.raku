use Clifford;

constant @x1 = <0 1 2 3 4 5 6 7 8 9 10>;
constant @y = <1 6 17 34 57 86 121 162 209 262 321>;

constant $x0 = [+] @e[^@x1];
constant $x1 = [+] @x1 Z* @e;
constant $x2 = [+] @x1 »**» 2  Z* @e;

constant $y  = [+] @y Z* @e;

my $J = $x1 ∧ $x2;
my $I = $x0 ∧ $J;

my $I2 = ($I·$I.reversion).Real;

.say for
(($y ∧ $J)·$I.reversion)/$I2,
(($y ∧ ($x2 ∧ $x0))·$I.reversion)/$I2,
(($y ∧ ($x0 ∧ $x1))·$I.reversion)/$I2;
