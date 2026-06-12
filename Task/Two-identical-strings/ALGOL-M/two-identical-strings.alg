begin
    integer function concatself(n);
    integer n;
    begin
        integer shift, copy, test;
        test := n;
        shift := n;
        while test > 0 do
        begin
            test := test / 2;
            shift := shift * 2;
        end;
        concatself := shift + n;
    end;

    procedure writebits(n);
    integer n;
    begin
        if n>1 then writebits(n/2);
        writeon(if n-n/2*2=0 then "0" else "1");
    end;

    integer n, m;
    n := 1;
    m := concatself(n);
    while m < 1000 do
    begin
        write(m, ": ");
        writebits(m);
        n := n + 1;
        m := concatself(n);
    end;
end
