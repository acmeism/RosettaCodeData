begin
integer array S[1:1200];
integer i,ok;

integer function gcd(a,b);
integer a,b;
gcd :=
    if a>b then gcd(a-b,b)
    else if a<b then gcd(a,b-a)
    else a;

integer function first(n);
integer n;
begin
    integer i;
    i := 1;
    while S[i]<>n do i := i + 1;
    first := i;
end;

S[1] := S[2] := 1;
for i := 2 step 1 until 600 do
begin
    S[i*2-1] := S[i] + S[i-1];
    S[i*2] := S[i];
end;

write("First 15 numbers:");
for i := 1 step 1 until 15 do
begin
    if i-i/5*5=1 then write(S[i]) else writeon(S[i]);
end;

write("");
write("First occurrence:");
for i := 1 step 1 until 10 do write(i, " at", first(i));
write(100, " at", first(100));

ok := 1;
for i := 1 step 1 until 999 do
begin
    if gcd(S[i], S[i+1]) <> 1 then
    begin
        write("gcd",S[i],",",S[i+1],"<> 1");
        ok := 0;
    end;
end;
if ok = 1 then write("The GCD of each pair of consecutive members is 1.");
end
