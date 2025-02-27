with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Rectangles;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Archimedean_Spiral is

   Width   : constant := 800;
   Height  : constant := 800;
   A       : constant := 4.2;
   B       : constant := 3.2;
   T_First : constant := 4.0;
   T_Last  : constant := 100.0;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Archimedean_Spiral is
      use type SDL.C.int;
      use Ada.Numerics.Elementary_Functions;
      Pi   : constant := Ada.Numerics.Pi;
      Step : constant := 0.002;
      T    : Float;
      R    : Float;
   begin
      T := T_First;
      loop
         R := A + B * T;
         Renderer.Draw
           (Point =>
              SDL.Video.Rectangles.Point'
                (X => Width / 2 + SDL.C.int (R * Cos (T, 2.0 * Pi)),
                 Y => Height / 2 - SDL.C.int (R * Sin (T, 2.0 * Pi))));
         exit when T >= T_Last;
         T := T + Step;
      end loop;
   end Draw_Archimedean_Spiral;

   procedure Wait is
      use type SDL.Events.Event_Types;
   begin
      loop
         while SDL.Events.Events.Poll (Event) loop
            if Event.Common.Event_Type = SDL.Events.Quit then
               return;
            end if;
         end loop;
      end loop;
   end Wait;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create
     (Win      => Window,
      Title    => "Archimedean spiral",
      Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
      Size     => SDL.Positive_Sizes'(Width, Height),
      Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill
     (Rectangle => SDL.Video.Rectangles.Rectangle'(0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((0, 220, 0, 255));

   Draw_Archimedean_Spiral;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Archimedean_Spiral;
