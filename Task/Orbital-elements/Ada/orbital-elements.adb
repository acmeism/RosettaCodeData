with Ada.Text_IO;   use Ada.Text_IO;
with Ada.Numerics.Generic_Real_Arrays;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Orbit is

   type Real is new Long_Float;

   package Real_Arrays is
      new Ada.Numerics.Generic_Real_Arrays (Real => Real);
   use Real_Arrays;

   package Math is
      new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Real);

   subtype Vector_3D is Real_Vector (1 .. 3);

   procedure Put (V : Vector_3D) is
      package Real_IO is
        new Ada.Text_Io.Float_IO (Num => Real);
   begin
      Put ("(");
      Real_IO.Put (V (1), Exp => 0, Aft => 6);  Put (",");
      Real_IO.Put (V (2), Exp => 0, Aft => 6);  Put (",");
      Real_IO.Put (V (3), Exp => 0, Aft => 6);  Put (")");
   end Put;

   function Mul_Add (V1 : Vector_3D;
                     X1 : Real;
                     V2 : Vector_3D;
                     X2 : Real)
                    return Vector_3D is
   begin
      return V1 * X1 + V2 * X2;
   end Mul_Add;

   procedure Rotate (R1    : out Vector_3D;
                     R2    : out Vector_3D;
                     I     :     Vector_3D;
                     J     :     Vector_3D;
                     Alpha :     Real) is
   begin
      R1 := Mul_Add (I, +Math.Cos (Alpha), J, Math.Sin (Alpha));
      R2 := Mul_Add (I, -Math.Sin (Alpha), J, Math.Cos (Alpha));
   end Rotate;

   type Orbital_State_Vectors is record
      Position : Vector_3D;
      Speed    : Vector_3D;
   end record;

   function Calculate_Orbital_State
      (Semimajor_Axis             : Real;
      Eccentricity                : Real;
      Inclination                 : Real;
      Longitude_Of_Ascending_Node : Real;
      Argument_Of_Periapsis       : Real;
      True_Anomaly                : Real)
     return Orbital_State_Vectors
   is
      I : Vector_3D := (1.0, 0.0, 0.0);
      J : Vector_3D := (0.0, 1.0, 0.0);
      K : constant Vector_3D := (0.0, 0.0, 1.0);
      P_R1, P_R2 : Vector_3D;
      State    : Orbital_State_Vectors;
      Position : Vector_3D renames State.Position;
      Speed    : Vector_3D renames State.Speed;
   begin
      Rotate (P_R1, P_R2, I, J, Longitude_Of_Ascending_Node);
      I := P_R1; J := P_R2;
      Rotate (P_R1, P_R2, J, K, Inclination);
      J := P_R1;
      Rotate (P_R1, P_R2, I, J, Argument_Of_Periapsis);
      I := P_R1; J := P_R2;
      declare
         L : constant Real :=
           Semimajor_Axis * (if (Eccentricity = 1.0) then 2.0
           else (1.0 - Eccentricity * Eccentricity));
         C : constant Real := Math.Cos (True_Anomaly);
         S : constant Real := Math.Sin (True_Anomaly);
         R : constant Real := L / (1.0 + Eccentricity * C);
         Rprime   : constant Real      := S * R * R / L;
      begin
         Position := Mul_Add (I, C, J, S) * R;
         Speed    := Mul_Add (I, Rprime * C - R * S,
                              J, Rprime * S + R * C);
         Speed := Speed / abs (Speed);
         Speed := Speed * Math.Sqrt (2.0 / R - 1.0 / Semimajor_Axis);
      end;
      return State;
   end Calculate_Orbital_State;

   Longitude : constant Real := 355.000 / (113.000 * 6.000);
   State     : constant Orbital_State_Vectors :=

     Calculate_Orbital_State
       (Semimajor_Axis              => 1.000,
        Eccentricity                => 0.100,
        Inclination                 => 0.000,
        Longitude_Of_Ascending_Node => Longitude,
        Argument_Of_Periapsis       => 0.000,
        True_Anomaly                => 0.000);
begin
   Put ("Position : "); Put (State.Position); New_Line;
   Put ("Speed    : "); Put (State.Speed);    New_Line;
end Orbit;
