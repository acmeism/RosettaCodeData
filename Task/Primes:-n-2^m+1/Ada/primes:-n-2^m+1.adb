with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Primes_n2m is
   P : Unbounded_Unsigned;
begin
   for N in Half_Word range 1..400 loop
      Set (P, N);
      for M in 0..Integer'Last loop
         if Is_Prime (P + 1, 10) = Prime then
            Put_Line
            (  "n:"   & Half_Word'Image (N) &
               " m:"  & Natural'Image (M)   &
               " p: " & Image (P + 1)
            );
            exit;
         end if;
         Mul (P, 2);
      end loop;
   end loop;
end Primes_n2m;
