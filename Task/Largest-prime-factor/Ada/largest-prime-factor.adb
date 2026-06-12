with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Largest_Prime_Factor is
   function Largest_Prime_Factor (X : Unbounded_Unsigned)
      return Unbounded_Unsigned is
      Result : Unbounded_Unsigned;
      Prime  : Unbounded_Unsigned := Two;
      Limit  : constant Unbounded_Unsigned := Sqrt (X);
   begin
      loop
         if X mod Prime = 0 then
            Result := Prime;
         end if;
         Next_Prime (Prime, 10);
         exit when Prime >= Limit;
      end loop;
      return Result;
   end Largest_Prime_Factor;
begin
   Put_Line (Image (Largest_Prime_Factor (Value ("600851475143"))));
end Largest_Prime_Factor;
