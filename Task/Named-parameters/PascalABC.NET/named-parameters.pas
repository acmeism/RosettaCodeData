##
procedure test(first: integer; second: integer := 2; third: integer := 3);
begin
end;

test(5);
test(5, 5);
test(5, third := 5, second := 5);
