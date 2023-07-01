with Ada.Numerics.Generic_Elementary_Functions;
package body Quaternions is
   package Elementary_Functions is
      new Ada.Numerics.Generic_Elementary_Functions (Real);
   use Elementary_Functions;
   function "abs" (Left : Quaternion) return Real is
   begin
      return Sqrt (Left.A**2 + Left.B**2 + Left.C**2 + Left.D**2);
   end "abs";
   function Conj (Left : Quaternion) return Quaternion is
   begin
      return (A => Left.A, B => -Left.B, C => -Left.C, D => -Left.D);
   end Conj;
   function "-" (Left : Quaternion) return Quaternion is
   begin
      return (A => -Left.A, B => -Left.B, C => -Left.C, D => -Left.D);
   end "-";
   function "+" (Left, Right : Quaternion) return Quaternion is
   begin
      return
      (  A => Left.A + Right.A, B => Left.B + Right.B,
         C => Left.C + Right.C, D => Left.D + Right.D
      );
   end "+";
   function "-" (Left, Right : Quaternion) return Quaternion is
   begin
      return
      (  A => Left.A - Right.A, B => Left.B - Right.B,
         C => Left.C - Right.C, D => Left.D - Right.D
      );
   end "-";
   function "*" (Left : Quaternion; Right : Real) return Quaternion is
   begin
      return
      (  A => Left.A * Right, B => Left.B * Right,
         C => Left.C * Right, D => Left.D * Right
      );
   end "*";
   function "*" (Left : Real; Right : Quaternion) return Quaternion is
   begin
      return Right * Left;
   end "*";
   function "*" (Left, Right : Quaternion) return Quaternion is
   begin
      return
      (  A => Left.A * Right.A - Left.B * Right.B - Left.C * Right.C - Left.D * Right.D,
         B => Left.A * Right.B + Left.B * Right.A + Left.C * Right.D - Left.D * Right.C,
         C => Left.A * Right.C - Left.B * Right.D + Left.C * Right.A + Left.D * Right.B,
         D => Left.A * Right.D + Left.B * Right.C - Left.C * Right.B + Left.D * Right.A
      );
   end "*";
   function Image (Left : Quaternion) return String is
   begin
      return Real'Image (Left.A) & " +"  &
             Real'Image (Left.B) & "i +" &
             Real'Image (Left.C) & "j +" &
             Real'Image (Left.D) & "k";
   end Image;
end Quaternions;
