begin

comment - calculate sum from k = 1 to 1000 of the sequence 1 / k^2;
real k, sum;
sum := 0;
for k := 1 step 1 until 1000 do
  sum := sum + 1 / (k * k);
outreal(1,sum); outstring(1,"\n");

end
