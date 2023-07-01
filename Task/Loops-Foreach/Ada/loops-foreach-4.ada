with Ada.Integer_Text_IO, Ada.Containers.Vectors;
use  Ada.Integer_Text_IO, Ada.Containers;

procedure Vector_Example is

   package Vector_Pkg is new Vectors (Natural, Integer);
   use     Vector_Pkg;

   procedure Print_Element (Position : Cursor) is
   begin
      Put (Element (Position));
   end Print_Element;

   V : Vector;

begin

   V.Append (1);
   V.Append (2);
   V.Append (3);

   -- Iterates through every element of the vector.
   V.Iterate (Print_Element'Access);

end Vector_Example;
