# unpack (widen) some data back into an a BOOL array #
INT i := 170;
BITS j := BIN i;
[bits width]BOOL k := j;

printf(($g", 8r"8r4d", "8(g)l$, i, j, k[bits width-8+1:]));

# now pack some data back into an INT #
k[bits width-8+1:] := (FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE);
j := bits pack(k);
i := ABS j;

printf(($g", 8r"8r4d", "8(g)l$, i, j, k[bits width-8+1:]))
