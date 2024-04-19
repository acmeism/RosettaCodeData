begin

integer i;

write("First approach :");
i := 10;
while (i >= 0) do
   begin
      writeon(i);
      i := i - 1;
   end;

write("Second approach:");
for i := 0 step 1 until 10 do
  writeon(10-i);

end
