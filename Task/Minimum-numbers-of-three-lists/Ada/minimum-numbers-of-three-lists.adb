with Ada.Text_Io; use Ada.Text_Io;

procedure Minimum_Three_Lists is

   type Number_Array is array (Positive range 1 .. 5) of Integer;

   Numbers_1 : constant Number_Array := (5,45,23,21,67);
   Numbers_2 : constant Number_Array := (43,22,78,46,38);
   Numbers_3 : constant Number_Array := (9,98,12,98,53);

   Result : Number_Array;
begin
   for A in Number_Array'Range loop
      declare
         R   : Integer renames Result    (A);
         N_1 : Integer renames Numbers_1 (A);
         N_2 : Integer renames Numbers_2 (A);
         N_3 : Integer renames Numbers_3 (A);
      begin
         R := Integer'Min (N_1, Integer'Min (N_2, N_3));
      end;
   end loop;

   for R of Result loop
      Put (R'Image);
   end loop;
   New_Line;
end Minimum_Three_Lists;
