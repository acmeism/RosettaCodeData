my @catalan := 1, { (state $n)++; 2*(2*$n-1)/($n+1) * $_ } ... *;

.say for @catalan[^15];
