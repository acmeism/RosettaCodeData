with Ada.Text_IO; use Ada.Text_IO;
procedure Test_Price_Fraction is
   -- Put the declarations here
   Value : Price := Price'First;
begin
   loop
      Put_Line (Price'Image (Value) & "->" & Price'Image (Scale (Value)));
      exit when Value = Price'Last;
      Value := Price'Succ (Value);
   end loop;
end Test_Price_Fraction;
