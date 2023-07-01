INT base = 16, from dec = 26;
BITS to bits;

FORMAT hex repr = $n(base)r2d$;

FILE f; STRING str;

associate(f, str);
putf(f, (hex repr, BIN from dec));
print(("Hex: ",str, new line));

reset(f);
getf(f, (hex repr, to bits));
print(("Int: ",ABS to bits, new line))
