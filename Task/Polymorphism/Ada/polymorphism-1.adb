package Shapes is
   type Point is tagged private;
   procedure Print(Item : in Point);
   function Setx(Item : in Point; Val : Integer) return Point;
   function Sety(Item : in Point; Val : Integer) return Point;
   function Getx(Item : in Point) return Integer;
   function Gety(Item : in Point) return Integer;
   function Create return Point;
   function Create(X : Integer) return Point;
   function Create(X, Y : Integer) return Point;

private
   type Point is tagged record
      X : Integer := 0;
      Y : Integer := 0;
   end record;
end Shapes;
