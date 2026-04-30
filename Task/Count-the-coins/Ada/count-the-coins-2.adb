with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   count: Integer;
begin
   count := 0;
   for penny in 0 .. 100 loop
      for nickel in 0 .. 20 loop
        for dime in 0 .. 10 loop
           for quarter in 0 .. 4 loop
              if (penny + 5 * nickel + 10 * dime + 25 * quarter = 100)
              then
                 Put_Line(Integer'Image(count+1) & ": " &
                          Integer'Image(penny)   & " pennies, " &
                          Integer'Image(nickel)  & " nickels, " &
                          Integer'Image(dime)    & " dimes, "   &
                          Integer'Image(quarter) & " quarters");
                 count := count + 1;
              end if;
           end loop;
        end loop;
      end loop;
   end loop;

  Put_Line("The number of ways to make change for a dollar is: " &  Integer'Image(count));
end Main;
