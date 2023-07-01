MODE FOO = STRUCT(CHAR u,l);
INT n := 26;
[n]FOO f;

# Additionally each item can be initialised #
FOR i TO UPB f DO f[i] := (REPR(ABS("A")-1+i), REPR(ABS("a")-1+i))  OD;

print((f, new line))
