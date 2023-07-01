begin
  integer prod, sum, x, y, z, one, three, seven;
  integer j;
  prod := 1;
  sum := 0;
  x := 5; y := -5; z := -2;
  one := 1;
  three := 3;
  seven := 7;

  for j := -three  step  three  until 3^3    ,
           -seven  step      x  until seven  ,
              555  step      1  until 550 - y,
               22  step -three  until -28    ,
             1927  step      1  until 1939   ,
                x  step      z  until y      ,
             11^x  step      1  until 11^x + one
  do begin
    sum := sum + iabs(j);
    if iabs(prod) < 2^27 & j != 0 then prod := prod*j
  end;

  outstring(1, " sum= "); outinteger(1, sum);  outstring(1, "\n");
  outstring(1, "prod= "); outinteger(1, prod); outstring(1, "\n")
end
