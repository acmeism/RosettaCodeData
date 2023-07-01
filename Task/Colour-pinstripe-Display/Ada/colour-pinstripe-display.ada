with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Palettes;
with SDL.Events.Events;

procedure Colour_Pinstripe_Display is

   Width   : constant := 1_200;
   Height  : constant := 800;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Pinstripe (Line_Width   : in Integer;
                             Line_Height  : in Integer;
                             Screen_Width : in Integer;
                             Y            : in Integer)
   is
      type Colour_Range is (Black, Red, Green, Blue, Magenta, Cyan, Yellow, White);
      Colours : constant array (Colour_Range) of SDL.Video.Palettes.Colour
        := (Black   => (0, 0, 0, 255),     Red   => (255, 0, 0, 255),
            Green   => (0, 255, 0, 255),   Blue  => (0, 0, 255, 255),
            Magenta => (255, 0, 255, 255), Cyan  => (0, 255, 255, 255),
            Yellow  => (255, 255, 0, 255), White => (255, 255, 255, 255));
      Col   : Colour_Range := Colour_Range'First;
      Count : constant Integer := Screen_Width / Line_Width;
   begin
      for A in 0 .. Count loop
         Renderer.Set_Draw_Colour (Colour => Colours (Col));
         Renderer.Fill (Rectangle => (X => SDL.C.int (A * Line_Width), Y => SDL.C.int (Y),
                                      Width  => SDL.C.int (Line_Width),
                                      Height => SDL.C.int (Line_Height)));
         Col := (if Col = Colour_Range'Last
                   then Colour_Range'First
                   else Colour_Range'Succ (Col));
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

   Draw_Pinstripe (1, Height / 4, Width, 0);
   Draw_Pinstripe (2, Height / 4, Width, 200);
   Draw_Pinstripe (3, Height / 4, Width, 400);
   Draw_Pinstripe (4, Height / 4, Width, 600);
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Colour_Pinstripe_Display;
