begin
    integer function mod(a, b);
    integer a, b;
    mod := a-a/b*b;

    integer function divisible(n);
    integer n;
    begin
        integer r, p, c, d;
        p := 1;
        c := n;
        r := 0;
        while c <> 0 do
        begin
            d := mod(c, 10);
            if d = 0 then go to stop;
            if mod(n, d) <> 0 then go to stop;
            p := p * d;
            c := c / 10;
        end;
        if mod(n, p) <> 0 then r := 1;
    stop:
        divisible := r;
    end;

    integer c, n;
    c := 0;
    for n := 1 step 1 until 1000 do
    begin
        if divisible(n) <> 0 then
        begin
            if (c-1)/10 <> c/10 then
                write(n)
            else
                writeon(n);
            c := c + 1;
        end;
    end;
    write("");
end
