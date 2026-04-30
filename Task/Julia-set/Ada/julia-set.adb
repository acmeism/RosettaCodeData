with Ada.Numerics.Generic_Complex_Types;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Palettes;
with SDL.Events.Events;

procedure Julia_Set is

   Width      : constant := 1_200;
   Height     : constant := 900;

   type Real is new Float;
   package Complex_Real is
      new Ada.Numerics.Generic_Complex_Types (Real);
   use Complex_Real;

   Iter   : constant         := 100;
   C      : constant Complex := (Re => -0.70000, Im => 0.27015);
   Move   : constant Complex := (Re => 0.000,    Im => 0.000);
   Zoom   : constant         := 0.800;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   function Map (Width, Height : in Integer;
                 X, Y          : in Integer) return Complex
   is
      C : Complex;
      L : constant Real := Real (Integer'Max (Width, Height));
   begin
      C := (2.0 * Real (X - Width  / 2) / (L * Zoom),
            2.0 * Real (Y - Height / 2) / (L * Zoom));
      return C + Move;
   end Map;

   procedure Draw_Julia_Set is
      use type SDL.C.int;
      use SDL.Video.Palettes;
      Z : Complex;
   begin
      for Y in 0 .. Height loop
         for X in 0 .. Width loop
            Z := Map (Width, Height, X, Y);
            for N in 1 .. Iter loop
               Z := Z ** 2 + C;
               if abs (Z) > 2.0 then
                  Renderer.Set_Draw_Colour ((Red   => 2 * Colour_Component (N),
                                             Green => 255 - 2 * Colour_Component (N),
                                             Blue  => 150, Alpha => 255));
                  Renderer.Draw (Point => (X => SDL.C.int (X),
                                           Y => SDL.C.int (Y)));
                  exit;
               end if;
            end loop;
         end loop;
      end loop;
   end Draw_Julia_Set;

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
                                    Title    => "Julia set",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create  (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   Draw_Julia_Set;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Julia_Set;
