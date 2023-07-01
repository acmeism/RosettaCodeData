begin
integer function mod(a,b);
integer a,b;
mod := a-(a/b)*b;

integer function sumdgtsq(n);
integer n;
sumdgtsq :=
    if n = 0 then 0
    else mod(n,10)*mod(n,10) + sumdgtsq(n/10);

integer function happy(n);
integer n;
begin
    integer i;
    integer array seen[0:200];
    for i := 0 step 1 until 200 do seen[i] := 0;

    while seen[n] = 0 do
    begin
        seen[n] := 1;
        n := sumdgtsq(n);
    end;
    happy := if n = 1 then 1 else 0;
end;

integer i, n;
i := n := 0;
while n < 8 do
begin
    if happy(i) = 1 then
    begin
        write(i);
        n := n + 1;
    end;
    i := i + 1;
end;
end
