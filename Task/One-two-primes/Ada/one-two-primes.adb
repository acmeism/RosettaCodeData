with Ada.Text_IO;                 use Ada.Text_IO;
with Strings_Edit.Integers;       use Strings_Edit.Integers;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure One_Two_Primes is
   Start : Unbounded_Unsigned := From_Half_Word (10);
   P, X  : Unbounded_Unsigned;
   N     : Natural   := 2;
begin
   for N in 1..30 loop
Outer :
      for I in 0..2**N - 1 loop
         P := (Start - 1) / 9;
         for M in 0..Natural'Last loop
            X := P + Value (Image (M, Base => 2));
            if Is_Prime (X, 10) = Prime then
               Put_Line (Image (N) & ": " & Image (X));
               exit Outer;
            end if;
         end loop;
      end loop Outer;
      Mul (Start, 10);
   end loop;
end One_Two_Primes;
