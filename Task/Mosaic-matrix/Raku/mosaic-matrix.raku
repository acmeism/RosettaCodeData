sub checker ($n) { (^$n).map: { 1 xx $n Z× (flat ($_ %% 2, $_ % 2) xx *) } }

.put for checker 7;
put '';
.put for checker 8;
