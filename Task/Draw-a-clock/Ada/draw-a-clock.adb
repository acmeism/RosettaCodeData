with Ada.Numerics.Elementary_Functions;
with Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Draw_A_Clock is
   use Ada.Calendar;
   use Ada.Calendar.Formatting;
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;
   Offset   : Time_Zones.Time_Offset;

   procedure Draw_Clock (Stamp : Time)
   is
      use SDL.C;
      use Ada.Numerics.Elementary_Functions;
      Radi : constant array (0 .. 59) of int := (0 | 15 | 30 | 45 => 2,
                                                 5 | 10 | 20 | 25 | 35 | 40 | 50 | 55 => 1,
                                                 others => 0);
      Diam : constant array (0 .. 59) of int := (0 | 15 | 30 | 45 => 5,
                                                 5 | 10 | 20 | 25 | 35 | 40 | 50 | 55 => 3,
                                                 others => 1);
      Width  : constant int   := Window.Get_Surface.Size.Width;
      Height : constant int   := Window.Get_Surface.Size.Height;
      Radius : constant Float := Float (int'Min (Width, Height));
      R_1    : constant Float := 0.48 * Radius;
      R_2    : constant Float := 0.35 * Radius;
      R_3    : constant Float := 0.45 * Radius;
      R_4    : constant Float := 0.47 * Radius;
      Hour   : constant Hour_Number   := Formatting.Hour   (Stamp, Offset);
      Minute : constant Minute_Number := Formatting.Minute (Stamp, Offset);
      Second : constant Second_Number := Formatting.Second (Stamp);

      function To_X (A : Float; R : Float) return int is
         (Width / 2 + int (R * Sin (A, 60.0)));

      function To_Y (A : Float; R : Float) return int is
         (Height / 2 - int (R * Cos (A, 60.0)));

   begin
      SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
      Renderer.Set_Draw_Colour ((0, 0, 150, 255));
      Renderer.Fill (Rectangle => (0, 0, Width, Height));
      Renderer.Set_Draw_Colour ((200, 200, 200, 255));
      for A in 0 .. 59 loop
         Renderer.Fill (Rectangle => (To_X (Float (A), R_1) - Radi (A),
                                      To_Y (Float (A), R_1) - Radi (A), Diam (A), Diam (A)));
      end loop;
      Renderer.Set_Draw_Colour ((200, 200, 0, 255));
      Renderer.Draw (Line => ((Width / 2, Height / 2),
                              (To_X (5.0 * (Float (Hour) + Float (Minute) / 60.0), R_2),
                               To_Y (5.0 * (Float (Hour) + Float (Minute) / 60.0), R_2))));
      Renderer.Draw (Line => ((Width / 2, Height / 2),
                              (To_X (Float (Minute) + Float (Second) / 60.0, R_3),
                               To_Y (Float (Minute) + Float (Second) / 60.0, R_3))));
      Renderer.Set_Draw_Colour ((220, 0, 0, 255));
      Renderer.Draw (Line => ((Width / 2, Height / 2),
                              (To_X (Float (Second), R_4),
                               To_Y (Float (Second), R_4))));
      Renderer.Fill (Rectangle => (Width / 2 - 3, Height / 2 - 3, 7, 7));
   end Draw_Clock;

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

begin
   Offset := Time_Zones.UTC_Time_Offset;

   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Draw a clock",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(300, 300),
                                    Flags    => SDL.Video.Windows.Resizable);
   loop
      Draw_Clock (Clock);
      Window.Update_Surface;
      delay 0.200;
      exit when Poll_Quit;
   end loop;

   Window.Finalize;
   SDL.Finalise;
end Draw_A_Clock;
