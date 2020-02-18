with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Generic_Real_Arrays;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Palettes;
with SDL.Events.Events;

procedure Death_Star is

   Width   : constant := 400;
   Height  : constant := 400;

   package Float_Arrays is
      new Ada.Numerics.Generic_Real_Arrays (Float);
   use Ada.Numerics.Elementary_Functions;
   use Float_Arrays;

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;

   subtype Vector_3 is Real_Vector (1 .. 3);

   type Sphere_Type is record
      Cx, Cy, Cz : Integer;
      R          : Integer;
   end record;

   function Normalize (V : Vector_3) return Vector_3 is
      (V / Sqrt (V * V));

   procedure Hit (S      :     Sphere_Type;
                  X, Y   :     Integer;
                  Z1, Z2 : out Float;
                  Is_Hit : out Boolean)
   is
      NX    : constant Integer := X - S.Cx;
      NY    : constant Integer := Y - S.Cy;
      Zsq   : constant Integer := S.R * S.R - (NX * NX + NY * NY);
      Zsqrt : Float;
   begin
      if Zsq >= 0 then
         Zsqrt  := Sqrt (Float (Zsq));
         Z1     := Float (S.Cz) - Zsqrt;
         Z2     := Float (S.Cz) + Zsqrt;
         Is_Hit := True;
         return;
      end if;
      Z1     := 0.0;
      Z2     := 0.0;
      Is_Hit := False;
   end Hit;

   procedure Draw_Death_Star (Pos, Neg : Sphere_Type;
                              K, Amb   : Float;
                              Dir      : Vector_3)
   is
      Vec      : Vector_3;
      ZB1, ZB2 : Float;
      ZS1, ZS2 : Float;
      Is_Hit   : Boolean;
      S        : Float;
      Lum      : Integer;
   begin
      for Y in Pos.Cy - Pos.R .. Pos.Cy + Pos.R loop
         for X in Pos.Cx - Pos.R .. Pos.Cx + Pos.R loop
            Hit (Pos, X, Y, ZB1, ZB2, Is_Hit);
            if not Is_Hit then
               goto Continue;
            end if;
            Hit (Neg, X, Y, ZS1, ZS2, Is_Hit);
            if Is_Hit then
               if ZS1 > ZB1 then
                  Is_Hit := False;
               elsif ZS2 > ZB2 then
                  goto Continue;
               end if;
            end if;

            if Is_Hit then
               Vec := (Float (Neg.Cx - X),
                       Float (Neg.Cy - Y),
                       Float (Neg.Cz) - ZS2);
            else
               Vec := (Float (X - Pos.Cx),
                       Float (Y - Pos.Cy),
                       ZB1 - Float (Pos.Cz));
            end if;
            S := Float'Max (0.0, Dir * Normalize (Vec));

            Lum := Integer (255.0 * (S ** K + Amb) / (1.0 + Amb));
            Lum := Integer'Max (0, Lum);
            Lum := Integer'Min (Lum, 255);

            Renderer.Set_Draw_Colour ((SDL.Video.Palettes.Colour_Component (Lum),
                                       SDL.Video.Palettes.Colour_Component (Lum),
                                       SDL.Video.Palettes.Colour_Component (Lum),
                                       255));
            Renderer.Draw (Point => (SDL.C.int (X + Width  / 2),
                                     SDL.C.int (Y + Height / 2)));
            <<Continue>>
         end loop;
      end loop;
   end Draw_Death_Star;

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

   Direction : constant Vector_3    := Normalize ((20.0, -40.0, -10.0));
   Positive  : constant Sphere_Type := (0, 0, 0, 120);
   Negative  : constant Sphere_Type := (-90, -90, -30, 100);
begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Death star",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   Draw_Death_Star (Positive, Negative, 1.5, 0.2, Direction);
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Death_Star;
