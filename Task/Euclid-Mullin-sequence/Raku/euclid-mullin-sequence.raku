use Prime::Factor;

my @Euclid-Mullin = 2, { state $i = 1; (1 + [×] @Euclid-Mullin[^$i++]).&prime-factors.min } … *;

put 'First sixteen: ', @Euclid-Mullin[^16];
