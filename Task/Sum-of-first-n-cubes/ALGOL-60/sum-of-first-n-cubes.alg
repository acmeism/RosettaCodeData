begin

integer i, sum, limit, col;

limit := 49;
sum := 0;
col := 1;
for i := 0 step 1 until limit do
  begin
    sum := sum + (i * i * i);
    outinteger(1,sum);
    col := col + 1;
    if col > 10 then
      begin
        outstring(1,"\n");
        col := 1;
      end;
  end;

end
