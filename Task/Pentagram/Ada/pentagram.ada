with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Rectangles;
with SDL.Events.Events;

procedure Pentagram is

   Width  : constant := 600;
   Height : constant := 600;
   Offset : constant := 300.0;
   Radius : constant := 250.0;

   use SDL.Video.Rectangles;
   use SDL.C;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   type Node_Id is mod 5;
   Nodes : array (Node_Id) of Point;

   procedure Calculate is
      use Ada.Numerics.Elementary_Functions;
   begin
      for I in Nodes'Range loop
         Nodes (I) := (X => int (Offset + Radius * Sin (Float (I), Cycle => 5.0)),
                       Y => int (Offset - Radius * Cos (Float (I), Cycle => 5.0)));
      end loop;
   end Calculate;

   function Orient_2D (A, B, C : Point) return int is
      ((B.X - A.X) * (C.Y - A.Y) - (B.Y - A.Y) * (C.X - A.X));

   procedure Fill is
      Count : Natural;
   begin
      for Y in int (Offset - Radius) .. int (Offset + Radius) loop
         for X in int (Offset - Radius) .. int (Offset + Radius) loop
            Count := 0;
            for Node in Nodes'Range loop
               Count := Count +
                 (if Orient_2D (Nodes (Node), Nodes (Node + 2), (X, Y)) > 0 then 1 else 0);
            end loop;
            if Count in 4 .. 5 then
               Renderer.Draw (Point => (X, Y));
            end if;
         end loop;
      end loop;
   end Fill;

   procedure Draw_Outline is
   begin
      for Node in Nodes'Range loop
         Renderer.Draw (Line => (Nodes (Node), Nodes (Node + 2)));
      end loop;
   end Draw_Outline;

   procedure Wait is
      use type SDL.Events.Event_Types;
   begin
      loop
         SDL.Events.Events.Wait (Event);
         exit when Event.Common.Event_Type = SDL.Events.Quit;
      end loop;
   end Wait;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Pentagram",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   Calculate;
   Renderer.Set_Draw_Colour ((50, 50, 150, 255));
   Fill;
   Renderer.Set_Draw_Colour ((0, 220, 0, 255));
   Draw_Outline;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Pentagram;
