package Shapes.Circles is
   type Circle is new Point with private;
   procedure Print(Item : Circle);
   function Setx(Item : Circle; Val : Integer) return Circle;
   function Sety(Item : Circle; Val : Integer) return Circle;
   function Setr(Item : Circle; Val : Integer) return Circle;
   function Getr(Item : Circle) return Integer;
   function Create(P : Point) return Circle;
   function Create(P : Point; R : Integer) return Circle;
   function Create(X : Integer) return Circle;
   function Create(X : Integer; Y : Integer) return Circle;
   function Create(X : Integer; Y : Integer; R : Integer) return Circle;
   function Create return Circle;
private
   type Circle is new Point with record
      R : Integer := 0;
   end record;
end Shapes.Circles;
