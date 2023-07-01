with Ada.Containers.Vectors;
use  Ada.Containers;

procedure Vector_Example is

   package Vector_Pkg is new Vectors (Natural, Integer);
   use     Vector_Pkg;

   V : Vector;

begin

   V.Append (1);
   V.Append (2);
   V.Append (3);

end Vector_Example;
