with Ada.Text_Io;
with Ada.Containers.Vectors;

procedure Sorted is

   package Integer_Vectors is
     new Ada.Containers.Vectors (Index_Type   => Positive,
                                 Element_Type => Integer);
   use Integer_Vectors;

   package Vector_Sorting is
     new Integer_Vectors.Generic_Sorting;
   use Vector_Sorting;

   procedure Unique (Vec : in out Vector) is
      Res : Vector;
   begin
      for E of Vec loop
         if Res.Is_Empty or else Res.Last_Element /= E then
            Res.Append (E);
         end if;
      end loop;
      Vec := Res;
   end Unique;

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

   A : constant Vector := 5 & 1 & 3 & 8 & 9 & 4 & 8 & 7;
   B : constant Vector := 3 & 5 & 9 & 8 & 4;
   C : constant Vector := 1 & 3 & 7 & 9;
   R : Vector          := A & B & C;
begin
   Sort (R);
   Unique (R);
   Put (R);
end Sorted;
