pragma Ada_2022;
with Ada.Command_Line;  use Ada.Command_Line;
with Ada.Text_IO;       use Ada.Text_IO;
with Easy_Graphics;     use Easy_Graphics;

procedure Sierpinski_Triangle_Graphical is
   Max_Order : constant Integer := 8;
   subtype Valid_Order is Integer range 0 .. Max_Order;
   Length : constant Positive := 2 ** (Max_Order + 1);
   Order  : Valid_Order;
   Img    : Easy_Image := New_Image ((1, 1), (550, 550), BLACK);
   Turtle : Turtle_Rec := New_Turtle (Img'Unrestricted_Access);

   procedure Sier_Triangle (Order : Valid_Order; Length : Positive) is
   begin
      if Order > 0 then
         for I in 1 .. 3 loop
            Sier_Triangle (Order - 1, Length / 2);
            Turtle.Forward (Length);
            Turtle.Right (120);
         end loop;
      end if;
   end Triangle;

begin
   if Argument_Count /= 1 then
      Put_Line ("Usage: sierpinski_triangle_graphical <order>");
      Put_Line ("Where: <order>  is 0 .. 8");
      return;
   end if;
   Order := Natural'Value (Argument (1));
   Turtle.Pen_Color (MAGENTA);
   Turtle.Go_To ((25, 25));
   Turtle.Pen_Down;
   Sier_Triangle (Order, Length);
   Write_GIF (Img, "sierpinski_triangle.gif");
end Sierpinski_Triangle_Graphical;
