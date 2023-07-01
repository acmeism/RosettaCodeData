begin
integer function square(x);
integer x;
square := x * x;

integer function cube(x);
integer x;
cube := x * x * x;

integer c, s, seen;
seen := 0;
while seen < 30 do
begin
    while cube(c) < square(s) do
        c := c + 1;
    if square(s) <> cube(c) then
    begin
        if (seen/5 <> (seen-1)/5) then write("");
        writeon(square(s));
        seen := seen + 1;
    end;
    s := s + 1;
end;
end
