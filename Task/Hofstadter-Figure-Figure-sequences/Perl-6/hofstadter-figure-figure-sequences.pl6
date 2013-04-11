my @ffr;
my @ffs;

@ffr.plan: 0, 1, gather take @ffr[$_] + @ffs[$_] for 1..*;
@ffs.plan: 0, 2, 4..6, gather take @ffr[$_] ^..^ @ffr[$_+1] for 3..*;

say @ffr[1..10];

say "Rawks!" if (1...1000) eqv sort @ffr[1..40], @ffs[1..960];
