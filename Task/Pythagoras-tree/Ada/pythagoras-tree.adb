with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Rectangles;
with SDL.Events.Events;

procedure Pythagoras_Tree is

   Width   : constant := 600;
   Height  : constant := 600;
   Level   : constant := 7;

   type Point is record X, Y : Float; end record;
   B1 : constant Point := (X => 250.0, Y => 550.0);
   B2 : constant Point := (X => 350.0, Y => 550.0);

   Window   : SDL.Video.Windows.Window;
   Renderer : SDL.Video.Renderers.Renderer;
   Event    : SDL.Events.Events.Events;

   procedure Draw_Pythagoras_Tree (Level  : in Natural;
                                   P1, P2 : in Point)
   is
      use SDL.Video.Rectangles;
      Dx : constant Float := P2.X - P1.X;
      Dy : constant Float := P1.Y - P2.Y;
      R  : constant Point := (X => P2.X - Dy, Y => P2.Y - Dx);
      L  : constant Point := (X => P1.X - Dy, Y => P1.Y - Dx);
      M  : constant Point := (X => L.X + (Dx - Dy) / 2.0,
                              Y => L.Y - (Dx + Dy) / 2.0);

      CP1 : constant SDL.Video.Rectangles.Point := (C.int (P1.X), C.int (P1.Y));
      CP2 : constant SDL.Video.Rectangles.Point := (C.int (P2.X), C.int (P2.Y));
      CL  : constant SDL.Video.Rectangles.Point := (C.int (L.X),  C.int (L.Y));
      CR  : constant SDL.Video.Rectangles.Point := (C.int (R.X),  C.int (R.Y));
      CM  : constant SDL.Video.Rectangles.Point := (C.int (M.X),  C.int (M.Y));

      Square : constant SDL.Video.Rectangles.Line_Arrays :=
        ((CP1, CP2), (CP2, CR), (CR, CL), (CL, CP1));
      Triang : constant SDL.Video.Rectangles.Line_Arrays :=
        ((CR, CL), (CL, CM), (CM, CR));
   begin
      if Level > 0 then
         Renderer.Set_Draw_Colour (Colour => (0, 220, 0, 255));
         Renderer.Draw (Lines => Square);
         Renderer.Draw (Lines => Triang);

         Draw_Pythagoras_Tree (Level - 1, L, M);
         Draw_Pythagoras_Tree (Level - 1, M, R);
      end if;
   end Draw_Pythagoras_Tree;

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
                                    Title    => "Pythagoras tree",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));
   Renderer.Set_Draw_Colour ((0, 220, 0, 255));

   Draw_Pythagoras_Tree (Level, B1, B2);
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Pythagoras_Tree;
