with Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Discrete_Random;

with SDL.Video.Windows.Makers;
with SDL.Video.Renderers.Makers;
with SDL.Video.Surfaces;
with SDL.Video.Rectangles;
with SDL.TTFs.Makers;
with SDL.Events.Events;
with SDL.Events.Keyboards;
with SDL.Events.Mice;

procedure Honeycombs is
   use SDL.Video.Rectangles;
   use SDL.C;

   Width    : constant := 560;
   Height   : constant := 595;
   Offset_X : constant := 10.0;
   Offset_Y : constant := 40.0;
   Radius   : constant := 60.0;
   Rows     : constant := 4;
   Cols     : constant := 5;
   TTF_File : constant String := "NotoSans-Bold.ttf";
   TTF_Size_Cell : constant   := 72;
   TTF_Size_Sum  : constant   := 38;
   Offset_Sum_X  : constant   := 35;
   Offset_Sum_Y  : constant   := 530;

   type Node_Id    is mod 6;
   type Shape_List is array (Node_Id) of Point;

   type Cell_Info is record
      Center : Point;
      Marked : Boolean;
      Label  : String (1 .. 1);
   end record;
   type Cell_List  is array (Positive range <>) of Cell_Info;

   function Make_Shape return Shape_List is
      use Ada.Numerics.Elementary_Functions;
      Shape : Shape_List;
   begin
      for I in Shape'Range loop
         Shape (I) := (X => int (Radius * Cos (Float (I), Cycle => 6.0)),
                       Y => int (Radius * Sin (Float (I), Cycle => 6.0)));
      end loop;
      return Shape;
   end Make_Shape;

   function Make_Cells (Rows, Cols : in Positive) return Cell_List is
      subtype Label_Type is Character range 'A' .. 'Z';
      package Randoms is new Ada.Numerics.Discrete_Random (Label_Type);
      use Randoms;
      Y_Scale : constant Float := Ada.Numerics.Elementary_Functions.Sqrt (3.0);
      List    : Cell_List (1 .. Rows * Cols);
      Info    : Cell_Info;
      Gen     : Generator;
   begin
      Reset (Gen);
      for R in 1 .. Rows loop
         for C in 1 .. Cols loop
            Info.Center.X := int (Offset_X + Radius * 1.5 * Float (C));
            Info.Center.Y := int (Offset_Y + Radius * Y_Scale * (Float (R) -
                                                                   Float (C mod 2) / 2.0));
            Info.Marked    := False;
            Info.Label (1) := Random (Gen);
            List ((R - 1) * Cols + C) := Info;
         end loop;
      end loop;
      return List;
   end Make_Cells;

   Window    : SDL.Video.Windows.Window;
   Win_Surf  : SDL.Video.Surfaces.Surface;
   Renderer  : SDL.Video.Renderers.Renderer;
   Font_Cell : SDL.TTFs.Fonts;
   Font_Sum  : SDL.TTFs.Fonts;

   Cells     :           Cell_List := Make_Cells (Rows, Cols);
   Shape     : constant Shape_List := Make_Shape;
   Sum_Text  : String (1 .. Rows * Cols);
   Sum_Last  : Natural := Sum_Text'First - 1;

   function Orient_2D (A, B, C : Point) return int is
      ((B.X - A.X) * (C.Y - A.Y) - (B.Y - A.Y) * (C.X - A.X));

   function "+" (Left, Right : Point) return Point is
      ((Left.X + Right.X, Left.Y + Right.Y));

   function Inside (P : Point; Cell : Cell_Info) return Boolean is
      Count : Natural := 0;
   begin
      for Node in Shape'Range loop
         Count := Count +
           (if Orient_2D (Cell.Center + Shape (Node),
                          Cell.Center + Shape (Node + 1),
                          P) > 0 then 1 else 0);
      end loop;
      return Count = 6;
   end Inside;

   procedure Draw (Cell : Cell_Info) is
      Surface     : constant SDL.Video.Surfaces.Surface :=
        Font_Cell.Render_Solid (Cell.Label, (30, 230, 230, 255));
      Self_Area   : SDL.Video.Rectangles.Rectangle;
      Source_Area : SDL.Video.Rectangles.Rectangle := (0, 0, 0, 0);
   begin
      --  Fill
      for Y in int (-Radius) .. int (Radius) loop
         for X in int (-Radius) .. int (Radius) loop
            if Inside (Cell.Center + (X, Y), Cell) then
               Renderer.Draw (Point => Cell.Center + (X, Y));
            end if;
         end loop;
      end loop;

      --  Label
      Self_Area := (Cell.Center.X - Surface.Size.Width  / 2,
                    Cell.Center.Y - Surface.Size.Height / 2, 0, 0);
      Win_Surf.Blit (Self_Area, Surface, Source_Area);

      --  Outline
      Renderer.Set_Draw_Colour ((0, 0, 0, 255));
      for Id in Shape'Range loop
         Renderer.Draw (Line => (Cell.Center + Shape (Id),
                                 Cell.Center + Shape (Id + 1)));
      end loop;
   end Draw;

   procedure Find_And_Mark (Click : Point; Key : String) is
      Self_Area   : SDL.Video.Rectangles.Rectangle;
      Source_Area : SDL.Video.Rectangles.Rectangle := (0, 0, 0, 0);
   begin
      for Cell of Cells loop
         if not Cell.Marked and then (Inside (Click, Cell) or Cell.Label = Key) then
            Cell.Marked         := True;
            Sum_Last            := Sum_Last + 1;
            Sum_Text (Sum_Last) := Cell.Label (1);
            Renderer.Set_Draw_Colour ((230, 20, 220, 255));
            Draw (Cell);

            --  Update sum text
            Self_Area := (Offset_Sum_X, Offset_Sum_Y, 0, 0);
            Win_Surf.Blit
              (Self_Area, Font_Sum.Render_Solid (Sum_Text (Sum_Text'First .. Sum_Last),
                                                 (0, 200, 200, 255)), Source_Area);
            Window.Update_Surface;
            exit;
         end if;
      end loop;
   end Find_And_Mark;

   procedure Wait is
      use type SDL.Events.Event_Types;
      use SDL.Events.Keyboards;
      Event : SDL.Events.Events.Events;
   begin
      loop
         SDL.Events.Events.Wait (Event);
         case Event.Common.Event_Type is
            when SDL.Events.Quit => return;
            when SDL.Events.Mice.Button_Down =>
               Find_And_Mark
                 ((Event.Mouse_Button.X,
                   Event.Mouse_Button.Y), "");
            when SDL.Events.Keyboards.Key_Down =>
               Find_And_Mark
                 ((0, 0), Image (Event.Keyboard.Key_Sym.Key_Code));
               null;
            when others => null;
         end case;
      end loop;
   end Wait;

begin
   if not SDL.Initialise (Flags => SDL.Enable_Screen) then
      return;
   end if;
   if not SDL.TTFs.Initialise then
      null;
   end if;
   SDL.TTFs.Makers.Create (Font_Cell, TTF_File, TTF_Size_Cell);
   SDL.TTFs.Makers.Create (Font_Sum,  TTF_File, TTF_Size_Sum);

   SDL.Video.Windows.Makers.Create (Win      => Window,
                                    Title    => "Honeycombs",
                                    Position => SDL.Natural_Coordinates'(X => 10, Y => 10),
                                    Size     => SDL.Positive_Sizes'(Width, Height),
                                    Flags    => 0);
   Win_Surf := Window.Get_Surface;
   SDL.Video.Renderers.Makers.Create (Renderer, Window.Get_Surface);
   Renderer.Set_Draw_Colour ((0, 0, 0, 255));
   Renderer.Fill (Rectangle => (0, 0, Width, Height));

   for Cell of Cells loop
      Renderer.Set_Draw_Colour ((230, 230, 0, 255));
      Draw (Cell);
   end loop;
   Window.Update_Surface;

   Wait;
   Window.Finalize;
   SDL.Finalise;
end Honeycombs;
