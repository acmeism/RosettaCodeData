begin
integer function mod(a,b);
integer a,b;
mod := a-a/b*b;

integer function digitsum(n);
integer n;
digitsum :=
    if n=0 then 0
    else mod(n,10) + digitsum(n/10);

integer function chop(n);
integer n;
begin
    integer i;
    i := 1;
    while i<n do i := i * 10;
    i := i/10;
    chop := if i=0 then 0 else mod(n, i);
end;

integer function infix(n,h);
integer n,h;
begin
    integer pfx, sfx, r;
    r := if n=h then 1 else 0;
    pfx := h;
    while pfx <> 0 do
    begin
        sfx := pfx;
        while sfx <> 0 do
        begin
            if sfx = n then
            begin
                r := 1;
                go to stop;
            end;
            sfx := chop(sfx);
        end;
        pfx := pfx/10;
    end;
stop:
    infix := r;
end;

integer i, n, d;
n := 0;
for i := 0 step 1 until 999 do
begin
    d := digitsum(i);
    if infix(d, i) = 1 then
    begin
        if (n-1)/10 <> n/10 then write(i)
        else writeon(i);
        n := n + 1;
    end;
end;
end
