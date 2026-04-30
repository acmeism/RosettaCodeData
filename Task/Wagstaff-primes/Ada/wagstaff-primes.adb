with Ada.Text_IO;                 use Ada.Text_IO;

with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Wagstaff is
   M     : Unbounded_Unsigned;
   Count : Integer := 16;

   procedure Check (P : Half_Word) is
   begin
      if Is_Prime (P) = Prime then
         M := (Power_Of_Two (Bit_Count (P)) + 1) / 3;
         if Is_Prime (M, 10) = Prime then
            Count := Count - 1;
            Put_Line
            (  "p ="   & Half_Word'Image (P) & Character'Val (9)
            &  " m = " & Image (M)
            );
         end if;
      end if;
   end Check;
begin
   Check (3);
   for N in Half_Word range 1..Half_Word'Last loop
      Check (N * 6 - 1);
      exit when Count <= 0;
      Check (N * 6 + 1);
      exit when Count <= 0;
   end loop;
end Wagstaff;
