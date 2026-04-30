with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

with Generic_Unbounded_Array;

procedure Prime_Decomposition is
   type Unbounded_Unsigned_Array is
      array (Positive range <>) of Unbounded_Unsigned;
   function Decompose (X : Unbounded_Unsigned)
      return Unbounded_Unsigned_Array is
      package Unbounded_Arrays is
         new Generic_Unbounded_Array
             (  Positive,
                Unbounded_Unsigned,
                Unbounded_Unsigned_Array,
                Zero
             );
      Result : Unbounded_Arrays.Unbounded_Array;
      Count  : Natural            := 0;
      Factor : Unbounded_Unsigned := Two;
      Value  : Unbounded_Unsigned := X;
      Limit  : Unbounded_Unsigned := Sqrt (X);
   begin
      loop
         if Is_Zero (Value mod Factor) then
            loop
               Count := Count + 1;
               Result.Put (Count, Factor);
               Div (Value, Factor);
               exit when not Is_Zero (Value mod Factor);
            end loop;
            if Is_Prime (Value, 10) = Prime then
               Count := Count + 1;
               Result.Put (Count, Value);
               exit;
            end if;
         end if;
         Next_Prime (Factor, 10);
         exit when Factor > Limit;
      end loop;
      if Count = 0 then
         return (1..0 => Zero);
      else
         return Result.Vector (1..Count);
      end if;
   end Decompose;

   procedure Print (A : Unbounded_Unsigned_Array) is
   begin
      for I in A'Range loop
         if I > A'First then
            Put (", ");
         end if;
         Put (Image (A (I)));
      end loop;
      New_Line;
   end Print;
begin
   Print (Decompose (Two * 2 * 3));
   Print (Decompose (Two * 3 * 5 * 7 * 11 * 11 * 13 * 17));
   Print (Decompose (From_Half_Word (233) * 1103 * 2089));
   Print (Decompose (From_Half_Word (431) * 9719 * 2099863));
   Print (Decompose (From_Half_Word (179951) * 16860167264933));
end Prime_Decomposition;
