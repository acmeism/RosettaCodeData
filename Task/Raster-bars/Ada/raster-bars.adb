with Ada.Numerics.Elementary_Functions;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Palettes;
with SDL.Events.Events;

procedure Raster_Bars is

   Width   : constant := 1200;
   Height  : constant := 600;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   function Check_Quit return Boolean is
      use type SDL.Events.Event_Types;
      Event : SDL.Events.Events.Events;
   begin
      while SDL.Events.Events.Poll (Event) loop
         if Event.Common.Event_Type = SDL.Events.Quit then
            return True;
         end if;
      end loop;
      return False;
   end Check_Quit;

   procedure Draw_Raster_Bar (Y : Integer) is
      use SDL.Video.Palettes;
      use SDL.C;
      Cc : Colour_Component;
   begin
      for I in 0 .. 10 loop
         Cc := Colour_Component (50 + 20 * I);
         Renderer.Set_Draw_Colour ((Cc, Cc, Cc, 255));
         Renderer.Draw (Line => ((0,     C.int (Y + I)),
                                 (Width, C.int (Y + I))));
      end loop;
   end Draw_Raster_Bar;

   procedure Draw_Raster_Bar_V (X : Integer) is
      use SDL.Video.Palettes;
      use SDL.C;
      Cc : Colour_Component;
   begin
      for I in 0 .. 10 loop
         Cc := Colour_Component (250 - 20 * I);
         Renderer.Set_Draw_Colour ((Cc, Cc, Cc, 255));
         Renderer.Draw (Line => ((C.int (X + I), 0),
                                 (C.int (X + I), Height)));
      end loop;
   end Draw_Raster_Bar_V;

   procedure Raster_Bars is
      use Ada.Numerics.Elementary_Functions;
      Xc  : constant Integer := 800;
      Yc  : constant Integer := 200;
      XA  : constant Float   := 40.0;
      YA  : constant Float   := 30.0;
      N : Float := 0.0;
   begin
      loop
         Renderer.Set_Draw_Colour ((0, 0, 0, 255));
         Renderer.Fill (Rectangle => (0, 0, Width, Height));
         Draw_Raster_Bar (Yc + Integer (YA * Sin (N + 00.0, 360.0)));
         Draw_Raster_Bar (Yc + Integer (YA * Sin (N + 25.0, 360.0)));
         Draw_Raster_Bar (Yc + Integer (YA * Sin (N + 50.0, 360.0)));
         Draw_Raster_Bar (Yc + Integer (YA * Sin (N + 75.0, 360.0)));
         Draw_Raster_Bar_V (Xc + Integer (XA * Sin (0.6 * N + 00.0, 360.0)));
         Draw_Raster_Bar_V (Xc + Integer (XA * Sin (0.6 * N + 90.0, 360.0)));
         Draw_Raster_Bar_V (Xc + Integer (XA * Sin (0.6 * N + 180.0, 360.0)));
         Window.Update_Surface;
         if Check_Quit then
            exit;
         end if;
         delay 0.010;
         N := N + 4.0;
      end loop;
   end Raster_Bars;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Raster bar",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);

   Raster_Bars;

   Window.Finalize;
   SDL.Finalise;
end Raster_Bars;
