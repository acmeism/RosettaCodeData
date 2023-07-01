with Ada.Numerics.Discrete_Random;

procedure Generic_Shuffle (List : in out Array_Type) is
   package Discrete_Random is new Ada.Numerics.Discrete_Random(Result_Subtype => Integer);
   use Discrete_Random;
   K : Integer;
   G : Generator;
   T : Element_Type;
begin
   Reset (G);
   for I in reverse List'Range loop
      K := (Random(G) mod I) + 1;
      T := List(I);
      List(I) := List(K);
      List(K) := T;
   end loop;
end Generic_Shuffle;
