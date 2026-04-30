with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Extensible_Prime_Generator is
   Step   : Half_Word := 2;
   P      : Unbounded_Unsigned := Five;
   Count  : Integer   := 2;
   N      : Natural   := 0;
begin
   Put_Line ("First 20 primes:");
   Put (" 2 3");
   loop
      if Is_Prime (P, 10) = Prime then
         Count := Count + 1;
         if Count in 1..20 then
            Put (' ' & Image (P));
            if Count = 20 then
               New_Line;
               Put_Line ("Primes between 100 and 150:");
            end if;
         elsif P >= 100 and then P <= 150 then
            Put (' ' & Image (P));
         elsif P >= 7700 and then P <= 8000 then
            N := N + 1;
         end if;
         exit when Count = 10_000;
      end if;
      Add (P, Step);
      if Step = 2 then
         Step := 4;
      else
         Step := 2;
      end if;
   end loop;
   New_Line;
   Put_Line ("Primes between 7700 and 8000:" & Integer'Image (N));
   Put_Line ("Prime no." & Integer'Image (Count) & ": " & Image (P));
end Extensible_Prime_Generator;
