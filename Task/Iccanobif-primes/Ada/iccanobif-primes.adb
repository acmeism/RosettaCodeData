with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Iccanobif_Primes is
   Count : Natural := 0;
begin
   for N in Positive'Range loop
      declare
         S : String  := Image (Fibonacci (N));
         I : Integer := S'First;
         J : Integer := S'Last;
         C : Character;
      begin
         while J > I loop
            C := S (I);
            S (I) := S (J);
            S (J) := C;
            I := I + 1;
            J := J - 1;
         end loop;
         if Is_Prime (Value (S), 10) = Prime then
            Put_Line (S);
            Count := Count + 1;
            exit when Count = 25;
         end if;
      end;
   end loop;
end Iccanobif_Primes;
