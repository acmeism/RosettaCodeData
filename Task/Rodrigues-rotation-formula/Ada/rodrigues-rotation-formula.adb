with Ada.Text_Io;
use  Ada.Text_Io;
with Ada.Numerics.Elementary_Functions;
use  Ada.Numerics.Elementary_Functions;
procedure Rodrigues is
   type Vector is record
      X, Y, Z : Float;
   end record;
   function Image (V : in Vector) return String is
     ('[' & V.X'Image & ',' & V.Y'Image & ',' & V.Z'Image & ']');
   -- Basic operations
   function "+" (V1, V2 : in Vector)           return Vector is ((V1.X + V2.X,
                                                                  V1.Y + V2.Y,
                                                                  V1.Z + V2.Z));
   function "*" (V : in Vector; A : in Float)  return Vector is ((V.X*A, V.Y*A, V.Z*A));
   function "/" (V : in Vector; A : in Float)  return Vector is (V*(1.0/A));
   function "*" (V1, V2 : in Vector)           return Float  is (-- dot-product
                                                                 (V1.X*V2.X + V1.Y*V2.Y + V1.Z*V2.Z));
   function Norm(V : in Vector)                return Float  is (Sqrt(V*V));
   function Normalize(V : in Vector)           return Vector is (V /Norm(V));
   function Cross_Product (V1, V2 : in Vector) return Vector is (-- cross-product
                                                                 (V1.Y*V2.Z - V1.Z*V2.Y,
                                                                  V1.Z*V2.X - V1.X*V2.Z,
                                                                  V1.X*V2.Y - V1.Y*V2.X));
   function Angle (V1, V2 : in Vector)         return Float  is (Arccos((V1*V2) / (Norm(V1)*Norm(V2))));
   -- Rodrigues' rotation formula
   function Rotate (V, Axis : in Vector;
                    Theta   : in Float) return Vector is
      K : constant Vector := Normalize(Axis);
   begin
      return V*Cos(Theta) + Cross_Product(K,V)*Sin(Theta) + K*(K*V)*(1.0-Cos(Theta));
   end Rotate;
   --
   -- Rotate vector Source on Target
   Source : constant Vector := ( 0.0, 2.0, 1.0);
   Target : constant Vector := (-1.0, 2.0, 0.4);
begin
   Put_Line ("Vector     " & Image(Source));
   Put_Line ("rotated on " & Image(Target));
   Put_Line ("         = " & Image(Rotate(V     => Source,
                                          Axis  => Cross_Product(Source, Target),
                                          Theta => Angle(Source, Target))));
end Rodrigues;
