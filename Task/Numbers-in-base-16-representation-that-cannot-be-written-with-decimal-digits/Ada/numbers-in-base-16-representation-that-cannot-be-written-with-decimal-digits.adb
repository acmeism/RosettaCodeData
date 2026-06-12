with Ada.Text_IO;

procedure Numbers_In_Base_16 is

   package Natural_IO is new Ada.Text_IO.Integer_IO (Natural);
   use Ada.Text_IO, Natural_IO;

   function Is_Hex_Only (Value : Natural) return Boolean
   is (Value = 0 or
         (Value mod 16 >= 10 and then Is_Hex_Only (Value / 16)));

   subtype Test_Range is Natural range 1 .. 499;
   Count : Natural := 0;
begin
   for A in Test_Range loop
      if Is_Hex_Only (A) then
         Count := Count + 1;
         Put (A, Width => 3); Put (" = ");
         Put (A, Width => 6, Base => 16); Put ("   ");
         if Count mod 5 = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;
   Default_Width := 0;
   Put ("There are "); Put (Count);
   Put (" numbers in range ");
   Put (Test_Range'First); Put (" .. ");
   Put (Test_Range'Last);
   Put (" without decimal digits in hex representation.");
   New_Line;
end Numbers_In_Base_16;
