with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Rectangles;
with SDL.Events.Events;

procedure Fractal_Tree is

   Width   : constant := 600;
   Height  : constant := 600;
   Level   : constant := 13;
   Length  : constant := 130.0;
   X_Start : constant := 475.0;
   Y_Start : constant := 580.0;
   A_Start : constant := -1.54;
   Angle_1 : constant := 0.10;
   Angle_2 : constant := 0.35;
   C_1     : constant := 0.71;
   C_2     : constant := 0.87;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Tree (Level  : in Natural;
                        Length : in Float;
                        Angle  : in Float;
                        X, Y   : in Float)
   is
      use SDL;
      use Ada.Numerics.Elementary_Functions;
      Pi   : constant       := Ada.Numerics.Pi;
      X_2  : constant Float := X + Length * Cos (Angle, 2.0 * Pi);
      Y_2  : constant Float := Y + Length * Sin (Angle, 2.0 * Pi);
      Line : constant SDL.Video.Rectangles.Line_Segment
        := ((C.int (X), C.int (Y)), (C.int (X_2), C.int (Y_2)));
   begin
      if Level > 0 then
         Renderer.Set_Draw_Colour (Colour => (0, 220, 0, 255));
         Renderer.Draw (Line => Line);

         Draw_Tree (Level - 1, C_1 * Length, Angle + Angle_1, X_2, Y_2);
         Draw_Tree (Level - 1, C_2 * Length, Angle - Angle_2, X_2, Y_2);
      end if;
   end Draw_Tree;

   procedure Wait is
      use type SDL.Events.Event_Types;
   begin
      loop
         while SDL.Events.Events.Poll (Event) loop
            if Event.Common.Event_Type = SDL.Events.Quit then
               return;
            end if;
         end loop;
         delay 0.100;
      end loop;
   end Wait;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Fractal tree",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   Draw_Tree (Level, Length, A_Start, X_Start, Y_Start);
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Fractal_Tree;
