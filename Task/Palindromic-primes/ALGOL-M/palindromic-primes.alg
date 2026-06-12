begin

% return 1 if n is a palindrome, otherwise 0 %
integer function ispalindrome(n);
   integer n;
begin
   integer i, j, q;
   integer array d[1:10];
   j := 0;
   while n > 0 do   % decompose n into its digits %
     begin
       j := j + 1;
       q := n / 10;
       d[j] := n - q * 10;
       n := q;
     end;
   i := 1;
   % j already points at last digit %
   while i < j and d[i] = d[j] do
     begin
       i := i + 1;
       j := j - 1;
     end;
  ispalindrome := if d[i] = d[j] then 1 else 0;
end;

integer limit, i, j, false, true, count;
integer array primes[1:999];

limit := 999;
false := 0;
true := 1;

% every number above 1 is potentially prime %
primes[1] := 0;
for i := 2 step 1 until limit do
  primes[i] := true;

% sieve by striking out multiples of each prime found %
for i := 2 step 1 until limit do
  begin
    if primes[i] = true then
       for j := (i + i) step i until limit do
         primes[j] := false;
  end;

% display those that are palindromes %
count := 0;
for i := 2 step 1 until limit do
  begin
    if primes[i] = true and ispalindrome(i) = true then
      begin
        writeon(i, "  ");  % wraps nicely on 80 col screen %
        count := count + 1;
      end;
  end;

write(count, " palindromic primes were found");

end
