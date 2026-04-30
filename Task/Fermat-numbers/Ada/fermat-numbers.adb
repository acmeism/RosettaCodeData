with Ada.Text_IO;                 use Ada.Text_IO;
with Strings_Edit.Integers;       use Strings_Edit.Integers;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Fermat_Numbers is
   P : Unbounded_Unsigned;
begin
   for N in 0..10 loop
      P := Power_Of_Two (2 ** N) + 1;
      Put ("F(" & Image (N) & ") = " & Image (P));
      if Is_Prime (P, 10) = Prime then
         Put (" is prime");
      end if;
      New_Line;
   end loop;
end Fermat_Numbers;
