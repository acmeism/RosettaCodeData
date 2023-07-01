begin

integer function mod(a, b);
integer a, b;
mod := a-(a/b)*b;

integer function kprime(n, k);
integer n, k;
begin
    integer p, f;
    f := 0;
    p := 2;
    while f < k and p*p <= n do
    begin
        while mod(n,p) = 0 do
        begin
            n := n / p;
            f := f + 1;
        end;
        p := p + 1;
    end;
    if n > 1 then f := f + 1;
    if f = k then kprime := 1 else kprime := 0;
end;

integer i, c, k;
for k := 1 step 1 until 5 do
begin
    write("k =");
    writeon(k);
    writeon(": ");
    c := 0;
    i := 2;
    while c < 10 do
    begin
        if kprime(i, k) <> 0 then
        begin
            writeon(i);
            c := c + 1;
        end;
        i := i + 1;
    end;
end;
end
