begin
    procedure writebin(n);
    integer n;
    begin
        procedure inner(x);
        integer x;
        begin
            if x>1 then inner(x/2);
            writeon(if x-x/2*2=0 then "0" else "1");
        end;
        write(""); % start new line %
        inner(n);
    end;

    writebin(5);
    writebin(50);
    writebin(9000);
end
