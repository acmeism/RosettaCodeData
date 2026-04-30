with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Superelipse is

   Width  : constant := 600;
   Height : constant := 600;
   A      : constant := 200.0;
   B      : constant := 200.0;
   N      : constant := 2.5;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Superelipse
   is
      use type SDL.C.int;
      use Ada.Numerics.Elementary_Functions;
      Xx, Yy : Float;
      subtype Legal_Range is Float range 0.980 .. 1.020;
   begin
      for Y in 0 .. Height loop
         for X in 0 .. Width loop
            Xx := Float (X - Width  / 2);
            Yy := Float (Y - Height / 2);
            if (abs (Xx / A)) ** N + (abs (Yy / B)) ** N in Legal_Range then
               Renderer.Draw (Point => (X => Width  / 2 + SDL.C.int (Xx),
                                        Y => Height / 2 - SDL.C.int (Yy)));
            end if;

         end loop;
      end loop;
   end Draw_Superelipse;

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
                                    Title    => "Superelipse",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((0, 220, 0, 255));

   Draw_Superelipse;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Superelipse;
