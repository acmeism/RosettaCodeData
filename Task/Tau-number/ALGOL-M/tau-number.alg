begin

integer array dcount[1:1100];
integer i, j, n;

integer function mod(a,b);
integer a,b;
mod := a-a/b*b;

% Calculate counts of divisors for 1 .. 1100 %
for i := 1 step 1 until 1100 do dcount[i] := 1;
for i := 2 step 1 until 1100 do
begin
    j := i;
    while j <= 1100 do
    begin
        dcount[j] := dcount[j] + 1;
        j := j + i;
    end;
end;

n := 0;
i := 1;
while n < 100 do
begin
    if mod(i, dcount[i])=0 then
    begin
        if mod(n, 10)=0
            then write(i)
            else writeon(i);
        n := n + 1;
    end;
    i := i + 1;
end;
end
