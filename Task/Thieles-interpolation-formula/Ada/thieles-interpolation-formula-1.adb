with Ada.Numerics.Generic_Real_Arrays;

generic
   type Real is digits <>;
package Thiele is
   package Real_Arrays is new Ada.Numerics.Generic_Real_Arrays (Real);
   subtype Real_Array is Real_Arrays.Real_Vector;

   type Thiele_Interpolation (Length : Natural) is private;

   function Create (X, Y : Real_Array) return Thiele_Interpolation;
   function Inverse (T : Thiele_Interpolation; X : Real) return Real;
private
   type Thiele_Interpolation (Length : Natural) is record
      X, Y, RhoX : Real_Array (1 .. Length);
   end record;
end Thiele;
