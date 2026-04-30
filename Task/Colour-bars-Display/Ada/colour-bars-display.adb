with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Palettes;
with SDL.Events.Events;
with SDL.Events.Keyboards;

procedure Colour_Bars_Display is
   use type SDL.Events.Event_Types;
   use SDL.C;

   Colours : constant array (0 .. 7) of SDL.Video.Palettes.Colour :=
     ((0, 0, 0, 255),     (255, 0, 0, 255),
      (0, 255, 0, 255),   (0, 0, 255, 255),
      (255, 0, 255, 255), (0, 255, 255, 255),
      (255, 255, 0, 255), (255, 255, 255, 255));
   Window    : SDL.Video.Windows.Window;
   Renderer  : SDL.Video.Renderers.Renderer;
   Event     : SDL.Events.Events.Events;
   Bar_Width : int;
begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "",
                                    Position => SDL.Natural_Coordinates'(0, 0),
                                    Size     => SDL.Positive_Sizes'(0, 0),
                                    Flags    => SDL.Video.Windows.Full_Screen_Desktop);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);

   Bar_Width := Window.Get_Size.Width / 8;
   for A in Colours'Range loop
      Renderer.Set_Draw_Colour (Colour => Colours (A));
      Renderer.Fill (Rectangle => (X => SDL.C.int (A) * Bar_Width, Y => 0,
                                   Width  => Bar_Width,
                                   Height => Window.Get_Size.Height));
   end loop;
   Window.Update_Surface;

   Wait_Loop : loop
      while SDL.Events.Events.Poll (Event) loop
         exit Wait_Loop when Event.Common.Event_Type = SDL.Events.Keyboards.Key_Down;
      end loop;
      delay 0.050;
   end loop Wait_Loop;
   Window.Finalize;
   SDL.Finalise;
end Colour_Bars_Display;
