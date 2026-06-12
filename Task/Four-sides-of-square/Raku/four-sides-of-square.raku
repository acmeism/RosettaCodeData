sub hollow ($n) { [1 xx $n], |(0 ^..^ $n).map( { [flat 1, 0 xx $n - 2, 1] } ), [1 xx $n] }

.put for hollow 7;
put '';
.put for hollow 10;
