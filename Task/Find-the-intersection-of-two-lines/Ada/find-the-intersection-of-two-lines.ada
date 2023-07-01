with Ada.Text_IO;

procedure Intersection_Of_Two_Lines
is
   Do_Not_Intersect : exception;

   type Line is record
      a : Float;
      b : Float;
   end record;

   type Point is record
      x : Float;
      y : Float;
   end record;

   function To_Line(p1, p2 : in Point) return Line
   is
      a : constant Float := (p1.y - p2.y) / (p1.x - p2.x);
      b : constant Float := p1.y - (a * p1.x);
   begin
      return (a,b);
   end To_Line;

   function Intersection(Left, Right : in Line) return Point is
   begin
      if Left.a = Right.a then
         raise Do_Not_Intersect with "The two lines do not intersect.";
      end if;

      declare
         b : constant Float := (Right.b - Left.b) / (Left.a - Right.a);
      begin
         return (b, Left.a * b + Left.b);
      end;
   end Intersection;

   A1 : constant Line := To_Line((4.0, 0.0), (6.0, 10.0));
   A2 : constant Line := To_Line((0.0, 3.0), (10.0, 7.0));
   p : constant Point := Intersection(A1, A2);
begin
   Ada.Text_IO.Put(p.x'Img);
   Ada.Text_IO.Put_Line(p.y'Img);
end Intersection_Of_Two_Lines;
