with Ada.Numerics;
with Ada.Numerics.Elementary_Functions;
with Interfaces.C;
with Raylib;

--  Translated from C Raylib use
procedure Spinner is
   type Angle is mod 360;

   type Spinner is
      record
         Position : Raylib.Vector2;
         Degrees : Angle;
         Color : Raylib.Color;
      end record;

   type Spinner_Array is array (1 .. 5) of Spinner;

   Window_Size : constant Positive := 800;
   Window_Radius : constant Positive := Window_Size / 2;
   Spinner_Radius : constant Positive := 100;
   Spinner_Speed : constant Positive := 5;

   function To_Radians (A : Angle) return Float is
     (Float (A) * 2.0 * Ada.Numerics.Pi / 360.0);

   function Sin (A : Angle) return Float is
     (Ada.Numerics.Elementary_Functions.Sin (To_Radians (A)));

   function Cos (A : Angle) return Float is
     (Ada.Numerics.Elementary_Functions.Cos (To_Radians (A)));

   procedure OpenWindow is
      WS : constant Interfaces.C.int := Interfaces.C.int (Window_Size);
      Flag : constant Interfaces.C.unsigned :=
        Interfaces.C.unsigned (Raylib.FLAG_MSAA_4X_HINT);
   begin
      Raylib.SetConfigFlags (Flag);
      Raylib.InitWindow (WS, WS, "Spinner");
   end OpenWindow;

   procedure CloseWindow renames Raylib.CloseWindow;

   function "+" (A, B : Interfaces.C.C_float) return Interfaces.C.C_float
   renames Interfaces.C."+";
   function "-" (A, B : Interfaces.C.C_float) return Interfaces.C.C_float
   renames Interfaces.C."-";

   function End_Position (V : Raylib.Vector2; A : Angle) return Raylib.Vector2
   is
      SR : constant Float := Float (Spinner_Radius);
      EndX : constant Interfaces.C.C_float :=
        Interfaces.C.C_float (SR * Cos (A));
      EndY : constant Interfaces.C.C_float :=
        Interfaces.C.C_float (SR * Sin (A));
      EndP : constant Raylib.Vector2 := (V.x + EndX, V.y + EndY);
   begin
      return EndP;
   end End_Position;

   procedure Draw_Spinners (Spinners : Spinner_Array) is
      Thickness : constant Interfaces.C.C_float :=
        Interfaces.C.C_float (2);
   begin
      for S of Spinners loop
         Raylib.DrawLineEx
           (S.Position, End_Position (S.Position, S.Degrees),
            Thickness, S.Color);
      end loop;
   end Draw_Spinners;

   procedure Update_Angles (Spinners : in out Spinner_Array) is
      DT : constant Interfaces.C.C_float := Raylib.GetFrameTime;
   begin
      for S of Spinners loop
         S.Degrees := S.Degrees + Angle (Spinner_Speed * 100 * Integer (DT));
      end loop;
   end Update_Angles;

   procedure Animate_Spinners is
      WR : constant Interfaces.C.int
      := Interfaces.C.int (Window_Radius);
      WR_f : constant Interfaces.C.C_float
      := Interfaces.C.C_float (Window_Radius);
      Center : constant Raylib.Vector2 := (WR_f, WR_f);
      SR : constant Interfaces.C.C_float
      := Interfaces.C.C_float (Spinner_Radius);
      Spinners : Spinner_Array :=
        (
          (Center, 50, Raylib.GREEN),
          ((Center.x - SR, Center.y - SR), 50, Raylib.RED),
          ((Center.x - SR, Center.y + SR), 50, Raylib.WHITE),
          ((Center.x + SR, Center.y - SR), 50, Raylib.YELLOW),
          ((Center.x + SR, Center.y + SR), 50, Raylib.ORANGE)
        );
   begin
      OpenWindow;

      while Interfaces.C."not" (Raylib.WindowShouldClose) loop
         Raylib.ClearBackground (Raylib.DARKGRAY);
         Raylib.DrawCircle (WR, WR, WR_f, Raylib.BLACK);
         Draw_Spinners (Spinners);
         Update_Angles (Spinners);
      end loop;

      CloseWindow;
   end Animate_Spinners;

begin
   Animate_Spinners;
end Spinner;
