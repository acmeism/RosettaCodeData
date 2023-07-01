begin
comment arrays - Algol 60;

  procedure static;
  begin
    integer array x[0:4];
    x[0]:=10;
    x[1]:=11;
    x[2]:=12;
    x[3]:=13;
    x[4]:=x[0];
    outstring(1,"static at 4: ");
    outinteger(1,x[4]);
    outstring(1,"\n")
  end static;

  procedure dynamic(n); value n; integer n;
  begin
    integer array x[0:n-1];
    x[0]:=10;
    x[1]:=11;
    x[2]:=12;
    x[3]:=13;
    x[4]:=x[0];
    outstring(1,"dynamic at 4: ");
    outinteger(1,x[4]);
    outstring(1,"\n")
  end dynamic;

  static;
  dynamic(5)

end arrays
