begin
integer function mod(a,b);
integer a,b;
mod := a-(a/b)*b;

integer function digitsum(n);
integer n;
digitsum :=
    if n = 0 then 0
    else mod(n,10) + digitsum(n/10);

integer function nextharshad(n);
integer n;
begin
    integer ds;
loop:
    n := n + 1;
    ds := digitsum(n);
    if mod(n, ds) <> 0 then go to loop;
    nextharshad := n;
end;

integer i, n;
write("First 20 Harshad numbers:");
n := 0;
for i := 1 step 1 until 20 do
begin
    n := nextharshad(n);
    if mod(i,10)=1 then
        write(n)
    else
        writeon(n);
end;

write("First Harshad number above 1000:", nextharshad(1000));
end
