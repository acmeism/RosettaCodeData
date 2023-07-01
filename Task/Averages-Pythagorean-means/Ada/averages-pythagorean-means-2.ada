with Ada.Numerics.Generic_Elementary_Functions;
package body Pythagorean_Means is
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Float);
   function "**" (Left, Right : Float) return Float renames Math."**";

   function Arithmetic_Mean (Data : Set) return Float is
      Sum : Float := 0.0;
   begin
      for I in Data'Range loop
         Sum := Sum + Data (I);
      end loop;
      return Sum / Float (Data'Length);
   end Arithmetic_Mean;

   function Geometric_Mean (Data : Set) return Float is
      Product : Float := 1.0;
   begin
      for I in Data'Range loop
         Product := Product * Data (I);
      end loop;
      return Product**(1.0/Float(Data'Length));
   end Geometric_Mean;

   function Harmonic_Mean (Data : Set) return Float is
      Reciprocal_Sum : Float := 0.0;
   begin
      for I in Data'Range loop
         Reciprocal_Sum := Reciprocal_Sum + Data (I)**(-1);
      end loop;
      return Float (Data'Length) / Reciprocal_Sum;
   end Harmonic_Mean;

end Pythagorean_Means;
