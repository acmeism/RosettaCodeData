PROC a = (INT in k, PROC INT xl, x2, x3, x4, x5) INT:(
  INT k := in k;
  PROC b = INT: a(k-:=1, b, xl, x2, x3, x4);
  ( k<=0 | x4 + x5 | b )
);

test:(
 printf(($gl$,a(10, INT:1, INT:-1, INT:-1, INT:1, INT:0)))
)
