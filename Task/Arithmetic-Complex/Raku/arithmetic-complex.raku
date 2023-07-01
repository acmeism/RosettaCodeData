my $a = 1 + i;
my $b = pi + 1.25i;

.say for $a + $b, $a * $b, -$a, 1 / $a, $a.conj;
.say for $a.abs, $a.sqrt, $a.re, $a.im;
