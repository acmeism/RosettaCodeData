main:(
  INT max = 12;
  INT width = ENTIER(log(max)*2)+1;
  STRING empty = " "*width, sep="|", hr = "+" + (max+1)*(width*"-"+"+");
  FORMAT ifmt = $g(-width)"|"$; # remove leading zeros #

  printf(($gl$, hr));
  print(sep + IF width<2 THEN "x" ELSE " "*(width-2)+"x " FI + sep);
  FOR col TO max DO printf((ifmt, col)) OD;
  printf(($lgl$, hr));

  FOR row TO max DO
    [row:max]INT product;
    FOR col FROM row TO max DO product[col]:=row*col OD;
    STRING prefix=(empty+sep)*(row-1);
    printf(($g$, sep, ifmt, row, $g$, prefix, ifmt, product, $l$))
  OD;
  printf(($gl$, hr))
)
