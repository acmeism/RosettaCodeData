begin
    integer N;
    N := 100;
    begin
        integer array div[1:N];
        integer i, j, col;
        for i := 1 step 1 until N do div[i] := 1;
        for i := 2 step 1 until N do
            for j := i step i until N do
                div[j] := div[j] + i;

        col := 0;
        for i := 1 step 1 until N do begin
            if (col-1)/10 <> col/10 then
                write(div[i])
            else
                writeon(div[i]);
            col := col + 1;
        end;
    end;
end
