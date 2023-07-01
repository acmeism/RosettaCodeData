begin
procedure move(n, src, via, dest);
integer n;
string(1) src, via, dest;
begin
    if n > 0 then
    begin
        move(n-1, src, dest, via);
        write("Move disk from pole ");
        writeon(src);
        writeon(" to pole ");
        writeon(dest);
        move(n-1, via, src, dest);
    end;
end;

move(4, "1", "2", "3");
end
