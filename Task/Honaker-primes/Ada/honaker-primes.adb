with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;
with Strings_Edit.Integers;       use Strings_Edit.Integers;

procedure Honaker_Primes is
   function Sum (N : Half_Word) return Half_Word is
      Result : Half_Word := 0;
      Value  : Half_Word := N;
   begin
      while Value /= 0 loop
         Result := Result + Value mod 10;
         Value  := Value / 10;
      end loop;
      return Result;
   end Sum;

   Line    : String (1..80);
   Pointer : Integer   := 1;
   Count   : Half_Word := 0;
   N       : Integer   := 0;
   P       : Unbounded_Unsigned := Two;
begin
   loop
      N := N + 1;
      if Sum (Half_Word (N)) = Sum (To_Half_Word (P)) then
         Count := Count + 1;
         if Count <= 50 then
            Put (Line, Pointer, N, 10, False, 4, Strings_Edit.Right);
            Strings_Edit.Put (Line, Pointer, ": ");
            Put (Line, Pointer, Integer (To_Half_Word (P)), 10, False, 5);
            if Count mod 5 = 0 then
               Put_Line (Line (1..Pointer - 1));
               Pointer := 1;
            end if;
         end if;
      end if;
      exit when Count = 10_000;
      Next_Prime (P, 10);
   end loop;
   Put_Line (Image (N) & ": " & Half_Word'Image (To_Half_Word (P)));
end Honaker_Primes;
