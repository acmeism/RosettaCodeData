function Ackermann(m,n:Int64):Int64;
begin
    if m = 0 then
        Result := n + 1
    else if n = 0 then
        Result := Ackermann(m-1, 1)
    else
        Result := Ackermann(m-1, Ackermann(m, n - 1));
end;
