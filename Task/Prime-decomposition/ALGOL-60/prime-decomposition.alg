begin

integer procedure mod(a, b);
  value a, b; integer a, b;
begin
  mod := a - entier(a/b) * b;
end;

comment
  Decompose n into its prime factors and store
  in the array pf, returning the number found.
  If n is prime, it will be stored as the first
  and only factor;

integer procedure primefactors(n, pf);
  value n; integer n; integer array pf;
begin
  integer i, count;
  count := 1;
  i := 2;
  for i := i while (i * i) <= n do
    begin
      if mod(n, i) = 0 then
        begin
          pf[count] := i;
          count := count + 1;
          n := n / i;
        end
      else
        i := i + 1;
    end;
  pf[count] := n;
  primefactors := count;
end;


comment
  exercise the procedure by displaying the prime
  factors of the odd numbers from 77 to 99;

integer i, k, nfound;
integer array factors[1:32];
for i := 77 step 2 until 99 do
  begin
    nfound := primefactors(i, factors);
    outinteger(1,i);
    outstring(1,":  ");
    for k := 1 step 1 until nfound do
      outinteger(1,factors[k]);
    outstring(1,"\n");
  end;

end
