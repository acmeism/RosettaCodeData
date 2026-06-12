my @ppp = lazy flat 2, 3, 5, 7, 23, grep { .is-prime && .comb.sum.is-prime },
               flat (2..*).map: { flat ([X~] (2, 3, 5, 7) xx $_) X~ (3, 7) };

put 'Terms < 10,000: '.fmt('%34s'), @ppp[^(@ppp.first: * > 1e4, :k)];
put '991st through 1000th: '.fmt('%34s'), @ppp[990 .. 999];
put 'Crossing 10th order of magnitude: ', @ppp[9055..9060];
