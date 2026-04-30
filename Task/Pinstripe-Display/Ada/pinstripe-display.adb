with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Pinstripe_Display is

   Width   : constant := 800;
   Height  : constant := 400;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   use SDL;
   use type SDL.C.int;

   procedure Draw_Pinstripe (Line_Width   : in C.int;
                             Line_Height  : in C.int;
                             Screen_Width : in C.int;
                             Y            : in C.int)
   is
      Count : constant C.int := Screen_Width / (2 * Line_Width);
   begin
      Renderer.Set_Draw_Colour (Colour => (255, 255, 255, 255));
      for A in 0 .. Count loop
         Renderer.Fill (Rectangle => (X => 2 * A * Line_Width, Y => Y,
                                      Width  => Line_Width,
                                      Height => Line_Height));
      end loop;
   end Draw_Pinstripe;

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
                                    Title    => "Pinstripe",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   Draw_Pinstripe (1, Height / 4, Width, 0);
   Draw_Pinstripe (2, Height / 4, Width, 100);
   Draw_Pinstripe (3, Height / 4, Width, 200);
   Draw_Pinstripe (4, Height / 4, Width, 300);
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Pinstripe_Display;
