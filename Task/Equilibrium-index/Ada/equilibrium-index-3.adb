with Ada.Text_IO;
with Equilibrium;
with Ada.Containers.Vectors;

procedure Main is
   subtype Index_Type is Positive range 1 .. 7;
   package Vectors is new Ada.Containers.Vectors
      (Element_Type => Integer, Index_Type => Index_Type);
   type Plain_Array is array (Index_Type) of Integer;
   function Element (From : Plain_Array; Key : Index_Type) return Integer is
   begin
      return From (Key);
   end Element;

   package Vector_Equilibrium is new Equilibrium
      (Index_Type => Index_Type,
       Element_Type => Integer,
       Zero => 0,
       Array_Type => Vectors.Vector,
       Element => Vectors.Element);
   package Array_Equilibrium is new Equilibrium
      (Index_Type => Index_Type,
       Element_Type => Integer,
       Zero => 0,
       Array_Type => Plain_Array);

   My_Vector : Vectors.Vector;
   My_Array : Plain_Array := (-7, 1, 5, 2, -4, 3, 0);
   Vector_Result : Vector_Equilibrium.Index_Vectors.Vector;
   Array_Result : Array_Equilibrium.Index_Vectors.Vector :=
      Array_Equilibrium.Get_Indices (My_Array);
begin
   Vectors.Append (My_Vector, -7);
   Vectors.Append (My_Vector, 1);
   Vectors.Append (My_Vector, 5);
   Vectors.Append (My_Vector, 2);
   Vectors.Append (My_Vector, -4);
   Vectors.Append (My_Vector, 3);
   Vectors.Append (My_Vector, 0);
   Vector_Result := Vector_Equilibrium.Get_Indices (My_Vector);
   Ada.Text_IO.Put_Line ("Results:");
   Ada.Text_IO.Put ("Array: ");
   for I in Array_Result.First_Index .. Array_Result.Last_Index loop
      Ada.Text_IO.Put (Integer'Image (Array_Equilibrium.Index_Vectors.Element (Array_Result, I)));
   end loop;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put ("Vector: ");
   for I in Vector_Result.First_Index .. Vector_Result.Last_Index loop
      Ada.Text_IO.Put (Integer'Image (Vector_Equilibrium.Index_Vectors.Element (Vector_Result, I)));
   end loop;
   Ada.Text_IO.New_Line;
end Main;
