with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;
with Thiele;

procedure Main is
   package Math is new Ada.Numerics.Generic_Elementary_Functions
     (Long_Float);
   package Float_Thiele is new Thiele (Long_Float);
   use Float_Thiele;

   Row_Count : Natural := 32;

   X_Values   : Real_Array (1 .. Row_Count);
   Sin_Values : Real_Array (1 .. Row_Count);
   Cos_Values : Real_Array (1 .. Row_Count);
   Tan_Values : Real_Array (1 .. Row_Count);
begin
   -- build table
   for I in 1 .. Row_Count loop
      X_Values (I)   := Long_Float (I) * 0.05 - 0.05;
      Sin_Values (I) := Math.Sin (X_Values (I));
      Cos_Values (I) := Math.Cos (X_Values (I));
      Tan_Values (I) := Math.Tan (X_Values (I));
   end loop;
   declare
      Sin : Thiele_Interpolation := Create (Sin_Values, X_Values);
      Cos : Thiele_Interpolation := Create (Cos_Values, X_Values);
      Tan : Thiele_Interpolation := Create (Tan_Values, X_Values);
   begin
      Ada.Text_IO.Put_Line
        ("Internal Math.Pi:    " &
         Long_Float'Image (Ada.Numerics.Pi));
      Ada.Text_IO.Put_Line
        ("Thiele 6*InvSin(0.5):" &
         Long_Float'Image (6.0 * Inverse (Sin, 0.5)));
      Ada.Text_IO.Put_Line
        ("Thiele 3*InvCos(0.5):" &
         Long_Float'Image (3.0 * Inverse (Cos, 0.5)));
      Ada.Text_IO.Put_Line
        ("Thiele 4*InvTan(1):  " &
         Long_Float'Image (4.0 * Inverse (Tan, 1.0)));
   end;
end Main;
