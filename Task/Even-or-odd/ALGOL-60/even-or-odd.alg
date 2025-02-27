begin

integer i;

boolean procedure even(n);
  value n; integer n;
begin
  even := (n = entier(n/2) * 2);
end;

comment - exercise the function;
for i := 1 step 3 until 12 do
  begin
    outinteger(1,i);
    if even(i) then
      outstring(1,"is even\n")
    else
      outstring(1,"is odd\n");
  end;

end
