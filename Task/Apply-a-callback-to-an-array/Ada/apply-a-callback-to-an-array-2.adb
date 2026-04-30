pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;

procedure Array_Callback is
   type Integer_Array is array (Positive range <>) of Integer;
   A : constant Integer_Array := (for I in 1..10 => I);
   B : constant Integer_Array := (for I in A'Range => A (I) ** 2);
begin
   for I in B'Range loop
      Put (B (I)'Image);
   end loop;
   New_Line;
end Array_Callback;
