begin
integer function mod(a,b);
integer a,b;
mod := a-(a/b)*b;

integer function digitsum(n,base);
integer n,base;
digitsum := if n=0 then 0 else mod(n,base)+digitsum(n/base,base);

integer function isprime(n);
integer n;
begin
    integer i;
    isprime := 0;
    if n < 2 then go to stop;
    for i := 2 step 1 until n-1 do
    begin
        if mod(n,i) = 0 then go to stop;
    end;
    isprime := 1;
stop:
    i := i;
end;

integer i,d2,d3,n;
n := 0;
for i := 0 step 1 until 199 do
begin
    d2 := digitsum(i,2);
    d3 := digitsum(i,3);
    if isprime(d2) <> 0 and isprime(d3) <> 0 then
    begin
        if n/10 <> (n-1)/10 then write(i) else writeon(i);
        n := n + 1;
    end;
end;
end
