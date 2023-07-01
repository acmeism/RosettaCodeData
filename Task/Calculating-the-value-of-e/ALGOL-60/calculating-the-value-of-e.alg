begin

real fact, n, result, epsilon;
fact := 1.0;
result := 2.0;
n := 2.0;
epsilon := 0.000000000001;  comment 1E-12;
for n := n while fact >= epsilon do
  begin
    fact := fact / n;
    n := n + 1;
    result := result + fact;
  end;

outstring(1,"Computed value of e  =");
outreal(1, result);
outstring(1,"\nValue of e as exp(1) =");
outreal(1,exp(1.0));
outstring(1,"\nPublished value of e = 2.718281828459045");

end
