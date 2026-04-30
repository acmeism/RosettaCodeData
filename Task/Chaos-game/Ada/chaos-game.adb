pragma Ada_2022;
with Ada.Numerics;  use Ada.Numerics;
with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Easy_Graphics; use Easy_Graphics;

procedure Chaos_Game is
   Img : Easy_Image := New_Image ((1, 1), (512, 512), WHITE);

   procedure Chaos (Image        : in out Easy_Image;
                    Vertex_Count : Positive;
                    Radius       : Float;
                    Iters        : Positive) is
      type Vertex_Array is array (1 .. Vertex_Count) of Point;
      Vertices : Vertex_Array;
      subtype Vertex_Range is Integer range 1 .. Vertex_Count;
      package Rand_V is new Ada.Numerics.Discrete_Random (Vertex_Range);
      use Rand_V;
      Gen : Generator;
      Half_X  : constant Integer := X_Last (Image) / 2;
      Half_Y  : constant Integer := Y_Last (Image) / 2;
      Half_Pi : constant Float   := Float (Pi) / 2.0;
      Two_Pi  : constant Float   := Float (Pi) * 2.0;
      V       : Integer;
      X       : Integer := Half_X;
      Y       : Integer := Half_Y;
   begin
      for V in 1 .. Vertex_Count loop
         Vertices (V).X := Half_X + Integer (Float (Half_X) *
                           Cos (Half_Pi + (Float (V - 1)) * Two_Pi / Float (Vertex_Count)));
         Vertices (V).Y := Half_Y - Integer (Float (Half_Y) *
                           Sin (Half_Pi + (Float (V - 1)) * Two_Pi / Float (Vertex_Count)));
      end loop;
      for I in 1 .. Iters loop
         V := Random (Gen);
         X := X + Integer (Radius * Float (Vertices (V).X - X));
         Y := Y + Integer (Radius * Float (Vertices (V).Y - Y));
         Plot (Image, (X, Y), BLACK);
      end loop;
   end Chaos;

begin
   Chaos (Img, 3, 0.5, 250_000);
   Write_GIF (Img, "chaos_game.gif");
end Chaos_Game;
