with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Combinations is
   generic
      type Integers is range <>;
   package Combinations is
      type Combination is array (Positive range <>) of Integers;
      procedure First (X : in out Combination);
      procedure Next (X : in out Combination);
      procedure Put (X : Combination);
   end Combinations;

   package body Combinations is
      procedure First (X : in out Combination) is
      begin
         X (1) := Integers'First;
         for I in 2..X'Last loop
            X (I) := X (I - 1) + 1;
         end loop;
      end First;
      procedure Next (X : in out Combination) is
      begin
         for I in reverse X'Range loop
            if X (I) < Integers'Val (Integers'Pos (Integers'Last) - X'Last + I) then
               X (I) := X (I) + 1;
               for J in I + 1..X'Last loop
                  X (J) := X (J - 1) + 1;
               end loop;
               return;
            end if;
         end loop;
         raise Constraint_Error;
      end Next;
      procedure Put (X : Combination) is
      begin
         for I in X'Range loop
            Put (Integers'Image (X (I)));
         end loop;
      end Put;
   end Combinations;

   type Five is range 0..4;
   package Fives is new Combinations (Five);
   use Fives;

   X : Combination (1..3);
begin
   First (X);
   loop
      Put (X); New_Line;
      Next (X);
   end loop;
exception
   when Constraint_Error =>
      null;
end Test_Combinations;
