begin

integer i;
boolean another;
i := 0;
another := true;
for i := i + 1 while another do
  begin
    outinteger(1,i);
    comment - repeat until i mod 6 = 0;
    if i = (i div 6) * 6 then another := false;
  end;

end
