-- Permutations by swapping
-- J. Carter     2024 Jun
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Permutations;

procedure Permutations_By_Swapping is
   package Permutations is new PragmARC.Permutations (Element => Positive);

   Permutation : Permutations.Sequence_Lists.Vector;
begin -- Permutations_By_Swapping
   Permutations.Generate (Initial => (1, 2, 3), Result => Permutation);

   Output : for I in 1 .. Permutation.Last_Index loop
      One_Permutation : declare
         Sequence : Permutations.Sequence renames Permutation.Element (I);
      begin -- One_Permutation
         Ada.Text_IO.Put (Item => '(');

         Print : for J in Sequence'Range loop
            Ada.Text_IO.Put (Item => (if J > 1 then "," else "") & Sequence (J)'Image);
         end loop Print;

         Ada.Text_IO.Put_Line (Item => ") " & (if I rem 2 = 0 then '-' else '+') & '1');
      end One_Permutation;
   end loop Output;
end Permutations_By_Swapping;
