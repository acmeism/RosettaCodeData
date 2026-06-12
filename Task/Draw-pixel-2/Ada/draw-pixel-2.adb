with Ada.Numerics.Discrete_Random;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Draw_A_Pixel_2 is

   Width   : constant := 640;
   Height  : constant := 480;

   use SDL.C;
   subtype Width_Range  is SDL.C.int range 0 .. Width - 1;
   subtype Height_Range is SDL.C.int range 0 .. Height - 1;
   package Random_Width  is new Ada.Numerics.Discrete_Random (Width_Range);
   package Random_Height is new Ada.Numerics.Discrete_Random (Height_Range);

   Width_Gen  : Random_Width.Generator;
   Height_Gen : Random_Height.Generator;
   Window     : SDL.Video.Windows.Window;
   Renderer   : SDL.Video.Renderers.Renderer;

   procedure Wait is
      use type SDL.Events.Event_Types;
      Event : SDL.Events.Events.Events;
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
   Random_Width.Reset (Width_Gen);
   Random_Height.Reset (Height_Gen);

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Draw a pixel 2",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((255, 255, 0, 255));
   Renderer.Draw (Point => (X => Random_Width.Random (Width_Gen),
                            Y => Random_Height.Random (Height_Gen)));
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Draw_A_Pixel_2;
