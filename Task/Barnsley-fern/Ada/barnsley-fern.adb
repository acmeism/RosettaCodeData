with Ada.Numerics.Discrete_Random;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Barnsley_Fern is

   Iterations : constant := 1_000_000;
   Width      : constant := 500;
   Height     : constant := 750;
   Scale      : constant := 70.0;

   type Percentage is range 1 .. 100;
   package Random_Percentages is
      new Ada.Numerics.Discrete_Random (Percentage);

   Gen      : Random_Percentages.Generator;
   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Barnsley_Fern is
      use type SDL.C.int;
      subtype F1_Range is Percentage range Percentage'First  .. Percentage'First;
      subtype F2_Range is Percentage range F1_Range'Last + 1 .. F1_Range'Last + 85;
      subtype F3_Range is Percentage range F2_Range'Last + 1 .. F2_Range'Last + 7;
      subtype F4_Range is Percentage range F3_Range'Last + 1 .. F3_Range'Last + 7;

      X0, Y0 : Float := 0.00;
      X1, Y1 : Float;
   begin
      for I in 1 .. Iterations loop
         case Random_Percentages.Random (Gen) is

            when F1_Range =>
               X1 := 0.00;
               Y1 := 0.16 * Y0;

            when F2_Range =>
               X1 :=  0.85 * X0 + 0.04 * Y0;
               Y1 := -0.04 * X0 + 0.85 * Y0 + 1.60;

            when F3_Range =>
               X1 := 0.20 * X0 - 0.26 * Y0;
               Y1 := 0.23 * X0 + 0.22 * Y0 + 1.60;

            when F4_Range =>
               X1 := -0.15 * X0 + 0.28 * Y0;
               Y1 :=  0.26 * X0 + 0.24 * Y0 + 0.44;

         end case;
         Renderer.Draw (Point => (X => Width / 2 + SDL.C.int (Scale * X1),
                                  Y => Height    - SDL.C.int (Scale * Y1)));
         X0 := X1; Y0 := Y1;

      end loop;
   end Draw_Barnsley_Fern;

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

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Barnsley Fern",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create  (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((0, 220, 0, 255));

   Random_Percentages.Reset (Gen);
   Draw_Barnsley_Fern;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Barnsley_Fern;
