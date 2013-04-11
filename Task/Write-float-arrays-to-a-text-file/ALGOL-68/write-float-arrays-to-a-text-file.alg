PROC writedat = (STRING filename, []REAL x, y, INT x width, y width)VOID: (
  FILE f;
  INT errno = open(f, filename, stand out channel);
  IF errno NE 0 THEN stop FI;
  FOR i TO UPB x DO
    # FORMAT := IF the absolute exponent is small enough, THEN use fixed ELSE use float FI; #
    FORMAT repr x := ( ABS log(x[i])<x width | $g(-x width,x width-2)$ | $g(-x width,x width-4,-1)$ ),
           repr y := ( ABS log(y[i])<y width | $g(-y width,y width-2)$ | $g(-y width,y width-4,-1)$ );
    putf(f, (repr x, x[i], $" "$, repr y, y[i], $l$))
  OD;
  close(f)
);
# Example usage: #
test:(
  []REAL x = (1, 2, 3, 1e11);
  [UPB x]REAL y; FOR i TO UPB x DO y[i]:=sqrt(x[i]) OD;
  printf(($"x before:"$, $xg$, x, $l$));
  printf(($"y before:"$, $xg$, y, $l$));
  writedat("sqrt.dat", x, y, 3+2, 5+2);

  printf($"After:"l$);
  FILE sqrt dat;
  INT errno = open(sqrt dat, "sqrt.dat", stand in channel);
  IF errno NE 0 THEN stop FI;
  on logical file end(sqrt dat, (REF FILE sqrt dat)BOOL: stop);
  TO UPB x DO
    STRING line;
    get(sqrt dat, (line, new line));
    print((line,new line))
  OD
)
