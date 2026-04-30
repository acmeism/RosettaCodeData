with Ada.Numerics.Discrete_Random;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Events.Events;

procedure Brownian_Tree is

   Width   : constant := 800;
   Height  : constant := 600;
   Points  : constant := 50_000;

   subtype Width_Range  is Integer range 1 .. Width;
   subtype Height_Range is Integer range 1 .. Height;
   type    Direction    is (N, NE, E, SE, S, SW, W, NW);
   package Random_Width   is new Ada.Numerics.Discrete_Random (Width_Range);
   package Random_Height  is new Ada.Numerics.Discrete_Random (Height_Range);
   package Random_Direc   is new Ada.Numerics.Discrete_Random (Direction);

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   Width_Gen  : Random_Width.Generator;
   Height_Gen : Random_Height.Generator;
   Direc_Gen  : Random_Direc.Generator;

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

   procedure Draw_Brownian_Tree is
      Field : array (Width_Range, Height_Range) of Boolean := (others => (others => False));
      X     : Width_Range;
      Y     : Height_Range;
      Direc : Direction;

      procedure Random_Free (X : out Width_Range; Y : out Height_Range) is
      begin
         --  Find free random spot
         loop
            X := Random_Width.Random (Width_Gen);
            Y := Random_Height.Random (Height_Gen);
            exit when Field (X, Y) = False;
         end loop;
      end Random_Free;

   begin
      --  Seed
      Field (Random_Width.Random  (Width_Gen),
             Random_Height.Random (Height_Gen)) := True;

      for I in 0 .. Points loop
         Random_Free (X, Y);
         loop
            --  If collide with wall then new random start
            while
              X = Width_Range'First  or X = Width_Range'Last or
              Y = Height_Range'First or Y = Height_Range'Last
            loop
               Random_Free (X, Y);
            end loop;
            exit when Field (X - 1, Y - 1) or Field (X, Y - 1) or Field (X + 1, Y - 1);
            exit when Field (X - 1, Y)     or                     Field (X + 1, Y);
            exit when Field (X - 1, Y + 1) or Field (X, Y + 1) or Field (X + 1, Y + 1);
            Direc := Random_Direc.Random (Direc_Gen);
            case Direc is
               when NW | N | NE => Y := Y - 1;
               when SW | S | SE => Y := Y + 1;
               when others => null;
            end case;
            case Direc is
               when NW | W | SW => X := X - 1;
               when SE | E | NE => X := X + 1;
               when others => null;
            end case;
         end loop;
         Field (X, Y) := True;
         Renderer.Draw (Point => (SDL.C.int (X), SDL.C.int (Y)));

         if I mod 100 = 0 then
            if Poll_Quit then
               return;
            end if;
            Window.Update_Surface;
         end if;
      end loop;
   end Draw_Brownian_Tree;

begin
   Random_Width.Reset  (Width_Gen);
   Random_Height.Reset (Height_Gen);
   Random_Direc.Reset  (Direc_Gen);

   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Brownian tree",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((200, 200, 200, 255));

   Draw_Brownian_Tree;
   Window.Update_Surface;

   loop
      exit when Poll_Quit;
      delay 0.050;
   end loop;
   Window.Finalize;
   SDL.Finalise;
end Brownian_Tree;
