with Ada.Text_Io;
with Ada.Numerics.Discrete_Random;

procedure Adjacent_Numbers is

   Adjacent_Length : constant := 5;

   subtype Digit is Character range '0' .. '9';
   package Random_Digits
   is new Ada.Numerics.Discrete_Random (Digit);

   Gen   : Random_Digits.Generator;
   Line  : String (1 .. 1000);
   Large : Natural := Natural'First;
   Small : Natural := Natural'Last;
begin
   Random_Digits.Reset (Gen);
   Line := (others => Random_Digits.Random (Gen));

   for I in Line'First .. Line'Last - Adjacent_Length + 1 loop
      declare
         Window : String renames Line (I .. I + Adjacent_Length - 1);
      begin
         Large := Natural'Max (Large, Natural'Value (Window));
         Small := Natural'Min (Small, Natural'Value (Window));
      end;
   end loop;
   Ada.Text_Io.Put_Line ("The largest number : " & Natural'Image (Large));
   Ada.Text_Io.Put_Line ("The smallest number: " & Natural'Image (Small));
end Adjacent_Numbers;
