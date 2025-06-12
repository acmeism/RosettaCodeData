begin

comment - return n mod m;
integer procedure mod(n, m);
  value n, m; integer n, m;
begin
  mod := n - entier(n / m) * m;
end;

comment - count, and optionally display, proper divisors of n;
integer procedure pdc(n, display);
  value n; integer n; boolean display;
begin
  integer i, limit, count;
  count := 1;
  i := 2;
  limit := n / 2;
  if display then
    begin
      outinteger(1,n); outstring(1,": "); outinteger(1,1);
    end;
  for i := i while i <= limit do
    begin
      if mod(n, i) = 0 then
        begin
          if display then outinteger(1,i);
          count := count + 1;
        end;
      i := i + 1;
      if count = 1 then limit := n / i;
    end;
  if display then outstring(1,"\n");
  pdc := count;
end;

integer i, junk, limit;
comment - first part of task;
outstring(1,"Proper divisors of first ten numbers\n");
for i := 1 step 1 until 10 do
  junk := pdc(i, true); comment - we don't need the return value;
outstring(1,"\n");

comment
  Calling pdc() 20000 times to find the highest number of proper
  divisors turns out to be hugely inefficient, so we take a
  different approach for the second part of the task;
limit := 20000;
outstring(1,"Searching to"); outinteger(1,limit);
outstring(1,"for number with most proper divisors:\n");
  begin
    integer i, j, ndiv, highdiv, highnum;
    integer array divcnt[1:limit];
    comment
      Create  a table of divisor counts for n = 1 to limit.
      This will include n itself, so for any n, the number
      of proper divisors will be one less;
    for i := 1 step 1 until limit do
      divcnt[i] := 0;
    for i := 1 step 1 until limit do
      for j := i step i until limit do
        divcnt[j] := divcnt[j] + 1;
    comment - search the table for the highest count;
    highdiv := 1;
    highnum := 1;
    for i := 2 step 1 until 20000 do
      begin
        ndiv := divcnt[i] - 1;
        if ndiv > highdiv then
          begin
            highdiv := ndiv;
            highnum := i;
          end;
      end;
    outstring(1,"The number is"); outinteger(1,highnum);
    outstring(1,"with"); outinteger(1,highdiv);
    outstring(1,"divisors");
  end;
