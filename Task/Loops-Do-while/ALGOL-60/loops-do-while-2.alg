begin

integer i;
boolean another;
i := 0;
another := true;
for i := i while another do
  begin
    i := i + 1;
    outinteger(1,i);
    comment - stop once i mod 6 = 0;
    if i = (i div 6) * 6 then another := false;
  end;

end
