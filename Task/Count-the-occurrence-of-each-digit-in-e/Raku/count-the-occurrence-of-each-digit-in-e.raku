constant 𝑒 = [\+] flat 1, [\/] 1.FatRat..*;

sub e-count ($n) {
    my @digits = 𝑒[$n / 2.7].substr(0,$n+1).comb.classify(*).sort.skip(1).map: {.key => .value.elems};
   .say for @digits;
   say 'Total digits: ', @digits».value.sum;
   say '';
}

.&e-count for 4000, 6000;
