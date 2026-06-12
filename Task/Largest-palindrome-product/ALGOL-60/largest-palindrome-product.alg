begin
comment - return true if n is a palindrome;
boolean procedure ispalindrome(n);
  value n; integer n;
begin
  integer i, j, q;
  integer array d[1:10];
  comment - decompose n into its digits;
  j := 0;
  for j := j while n > 0 do
    begin
      j := j + 1;
      q := entier(n / 10);
      d[j] := n - q * 10;
      n := q;
    end;
  comment - move from outside in checking for equality;
  i := 1; comment - j is already equal to the number of digits;
  for i := i while (i < j) and (d[i] = d[j]) do
    begin
      i := i + 1;
      j := j - 1;
    end;
  ispalindrome := d[i] = d[j];
end;

integer i, j, product, largest, m1, m2;

outstring(1,"Largest product of two 3-digit numbers that is a palindrome:\n");
largest := 100 * 100;
for i := 100 step 1 until 999 do
  for j := i step 1 until 999 do
    begin
      product := i * j;
      if product > largest then
        begin
          if ispalindrome(product) then
             begin
               largest := product;
               m1 := i;
               m2 := j;
             end;
        end;
     end;
outinteger(1,largest);
outstring(1," (");
outinteger(1,m1);
outstring(1,"*");
outinteger(1,m2);
outstring(1,")\n");

end
