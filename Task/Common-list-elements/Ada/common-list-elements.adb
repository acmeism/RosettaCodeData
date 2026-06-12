with Ada.Text_Io;
with Ada.Containers.Vectors;

procedure Common is

   package Integer_Vectors is
     new Ada.Containers.Vectors (Index_Type   => Positive,
                                 Element_Type => Integer);
   use Integer_Vectors;

   function Common_Elements (Left, Right : Vector) return Vector is
      Res : Vector;
   begin
      for E of Left loop
         if Has_Element (Right.Find (E)) then
            Res.Append (E);
         end if;
      end loop;
      return Res;
   end Common_Elements;

   procedure Put (Vec : Vector) is
      use Ada.Text_Io;
   begin
      Put ("[");
      for E of Vec loop
         Put (E'Image);  Put (" ");
      end loop;
      Put ("]");
      New_Line;
   end Put;

   A : constant Vector := 2 & 5 & 1 & 3 & 8 & 9 & 4 & 6;
   B : constant Vector := 3 & 5 & 6 & 2 & 9 & 8 & 4;
   C : constant Vector := 1 & 3 & 7 & 6 & 9;
   R : Vector;
begin
   R := Common_Elements (A, B);
   R := Common_Elements (R, C);
   Put (R);
end Common;
