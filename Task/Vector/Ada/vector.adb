with Ada.Text_IO;

procedure Vector_Demo is
   type Vector is record
      X, Y : Float;
   end record;

   function "+" (A, B : Vector) return Vector is
      (A.X + B.X, A.Y + B.Y);

   function "-" (A, B : Vector) return Vector is
      (A.X - B.X, A.Y - B.Y);

   function "*" (S : Float; A : Vector) return Vector is
      (S * A.X, S * A.Y);

   function "/" (A : Vector; S : Float) return Vector is
      (A.X / S, A.Y / S);

   procedure Print (A : Vector) is
   begin
      Ada.Text_IO.Put_Line ("(" & A.X'Image & "," & A.Y'Image & ")");
   end Print;

   Example : Vector := (1.0, 1.0);
begin
   Print (Example + Example);
   Print (Example - Example);
   Print (2.0 * Example);
   Print (Example / 2.0);
end Vector_Demo;
