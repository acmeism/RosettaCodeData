with Ada.Text_IO;

procedure Twos_Complement is
   type Number is mod 2 ** 32;
   A : constant Number := 42;
   B : constant Number := not A + 1;
   Is_Negative : constant Boolean := A + B = 0;
begin
   Ada.Text_IO.Put_Line ("B = -A is " & Is_Negative'Image);
end Twos_Complement;
