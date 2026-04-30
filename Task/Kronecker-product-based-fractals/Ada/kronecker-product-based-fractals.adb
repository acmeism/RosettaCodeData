with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;
with SDL.Events.Mice;

procedure Kronecker_Fractals is

   Width  : constant := 800;
   Height : constant := 800;
   Order  : constant := 6;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   type Matrix is array (Positive range <>, Positive range <>) of Integer;

   function "*" (Left, Right : in Matrix) return Matrix is
      Result : Matrix
        (1 .. Left'Length (1) * Right'Length (1),
         1 .. Left'Length (2) * Right'Length (2));
      LI : Natural := 0;
      LJ : Natural := 0;
   begin
      for I in 0 .. Result'Length (1) - 1 loop
         for J in 0 .. Result'Length (2) - 1 loop
            Result (I + 1, J + 1) :=
              Left (Left'First (1) + (LI), Left'First (2) + (LJ))
              * Right
              (Right'First (1) + (I mod Right'Length (1)),
               Right'First (2) + (J mod Right'Length (2)));
            if (J + 1) mod Right'Length (2) = 0 then
               LJ := LJ + 1;
            end if;
         end loop;
         if (I + 1) mod Right'Length (1) = 0 then
            LI := LI + 1;
         end if;
         LJ := 0;
      end loop;
      return Result;
   end "*";

   function "**" (Base : Matrix; Exp : Positive) return Matrix is
      (case Exp is
         when 1      => Base,
         when 2      => Base * Base,
         when others => Base * Base ** (Exp - 1));

   procedure Draw_Matrix (LX, LY : Integer; M : Matrix) is
      use SDL.C;
   begin
      for Y in M'Range (1) loop
         for X in M'Range (2) loop
            if M (Y, X) /= 0 then
               Renderer.Draw (Point => (int (LX + X), int (LY + Y)));
            end if;
         end loop;
      end loop;
   end Draw_Matrix;

   type Fractals is (Cross, H, X, Sierpinski, U);
   Base : Fractals := Fractals'First;

   M : constant array (Fractals) of Matrix (1 .. 3, 1 .. 3) :=
     (Cross      => ((0, 1, 0), (1, 1, 1), (0, 1, 0)),
      H          => ((1, 0, 1), (1, 1, 1), (1, 0, 1)),
      X          => ((1, 0, 1), (0, 1, 0), (1, 0, 1)),
      Sierpinski => ((1, 1, 1), (1, 0, 1), (1, 1, 1)),
      U          => ((1, 0, 1), (1, 0, 1), (1, 1, 1)));

   procedure Draw is
   begin
      Renderer.Set_Draw_Colour ((0, 0, 0, 255));
      Renderer.Fill (Rectangle => (0, 0, Width, Height));

      Renderer.Set_Draw_Colour (Colour => (0, 220, 0, 255));
      Draw_Matrix (10, 10, M (Base) ** Order);
      Window.Update_Surface;
      Base := (if Base = Fractals'Last
                    then Fractals'First
                    else Fractals'Succ (Base));
   end Draw;

   procedure Event_Loop is
      use type SDL.Events.Event_Types;
      Event : SDL.Events.Events.Events;
   begin
      loop
         SDL.Events.Events.Wait (Event);
         case Event.Common.Event_Type is
            when SDL.Events.Quit             => return;
            when SDL.Events.Mice.Button_Down => Draw;
            when others                      => null;
         end case;
      end loop;
   end Event_Loop;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Kronecker fractals (Click to cycle)",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);

   Draw;
   Event_Loop;
   Window.Finalize;
   SDL.Finalise;
end Kronecker_Fractals;
