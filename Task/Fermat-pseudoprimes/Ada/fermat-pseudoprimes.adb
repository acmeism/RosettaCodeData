with Ada.Command_Line;            use Ada.Command_Line;
with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Fermat_Pseudoprimes is
   A : Unbounded_Unsigned := Zero;
   P : Unbounded_Unsigned;
   Count : Natural;
begin
   if Argument_Count /= 1 then
      Put_Line ("Usage: > fermat_pseudo_prime <max-number>");
      Set_Exit_Status (Failure);
      return;
   end if;
   for I in 1..20 loop
      Add (A, 1);
      Count := 0;
      P := Three;
      Put ("Base " & Image (A) & ':');
      for J in 4..Integer'Value (Argument (1)) loop
         Add (P, 1);
         if Is_Prime (P, 10) /= Prime and then
            Is_One (Mod_Pow (A, P - 1, P))
         then
            Count := Count + 1;
            if Count <= 20 then
               Put (' ' & Image (P));
            end if;
         end if;
      end loop;
      Put (" | total:" & Integer'Image (Count));
      New_Line;
   end loop;
end Fermat_Pseudoprimes;
