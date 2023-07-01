with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Rotating_Cube is

   Width  : constant := 500;
   Height : constant := 500;
   Offset : constant := 500.0 / 2.0;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;
   Quit     : Boolean := False;

   type Node_Id   is new Natural;
   type Point_3D  is record X, Y, Z : Float;   end record;
   type Edge_Type is record A, B    : Node_Id; end record;

   Nodes : array (Node_Id range <>) of Point_3D :=
     ((-100.0, -100.0, -100.0), (-100.0, -100.0, 100.0), (-100.0, 100.0, -100.0),
      (-100.0, 100.0, 100.0),   (100.0, -100.0, -100.0), (100.0, -100.0, 100.0),
      (100.0, 100.0, -100.0),   (100.0, 100.0, 100.0));
   Edges : constant array (Positive range <>) of Edge_Type :=
     ((0, 1), (1, 3), (3, 2), (2, 0), (4, 5), (5, 7),
      (7, 6), (6, 4), (0, 4), (1, 5), (2, 6), (3, 7));

   use Ada.Numerics.Elementary_Functions;

   procedure Rotate_Cube (AngleX, AngleY : in Float) is
      SinX : constant Float := Sin (AngleX);
      CosX : constant Float := Cos (AngleX);
      SinY : constant Float := Sin (AngleY);
      CosY : constant Float := Cos (AngleY);
      X, Y, Z : Float;
   begin
      for Node of Nodes loop
         X := Node.X;
         Y := Node.Y;
         Z := Node.Z;
         Node.X := X * CosX - Z * SinX;
         Node.Z := Z * CosX + X * SinX;
         Z := Node.Z;
         Node.Y := Y * CosY - Z * SinY;
         Node.Z := Z * CosY + Y * SinY;
      end loop;
   end Rotate_Cube;

   function Poll_Quit return Boolean is
      use type SDL.Events.Event_Types;
   begin
      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            return True;
         end if;
      end loop;
      return False;
   end Poll_Quit;

   procedure Draw_Cube (Quit : out Boolean) is
      use SDL.C;
      Pi : constant := Ada.Numerics.Pi;
      Xy1, Xy2 : Point_3D;
   begin
      Rotate_Cube (Pi / 4.0, Arctan (Sqrt (2.0)));
      for Frame in 0 .. 359 loop
         Renderer.Set_Draw_Colour ((0, 0, 0, 255));
         Renderer.Fill (Rectangle => (0, 0, Width, Height));

         Renderer.Set_Draw_Colour ((0, 220, 0, 255));
         for Edge of Edges loop
            Xy1 := Nodes (Edge.A);
            Xy2 := Nodes (Edge.B);
            Renderer.Draw (Line => ((int (Xy1.X + Offset), int (Xy1.Y + Offset)),
                                    (int (Xy2.X + Offset), int (Xy2.Y + Offset))));
         end loop;
         Rotate_Cube (Pi / 180.0, 0.0);
         Window.Update_Surface;
         Quit := Poll_Quit;
         exit when Quit;
         delay 0.020;
      end loop;
   end Draw_Cube;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Rotating cube",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);

   while not Quit loop
      Draw_Cube (Quit);
   end loop;

   Window.Finalize;
   SDL.Finalise;
end Rotating_Cube;
