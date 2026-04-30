with Ada.Text_IO;                 use Ada.Text_IO;
with Strings_Edit.Integers;       use Strings_Edit.Integers;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Moebius is
   function Moebius (N : Half_Word) return Integer is
      Prime  : Unbounded_Unsigned := One;
      Value  : Half_Word := N;
      Factor : Half_Word;
      Result : Integer := 1;
   begin
      while Value > 1 loop
         Next_Prime (Prime, 15);
         Factor := To_Half_Word (Prime);
         if Value mod Factor = 0 then
            Value := Value / Factor;
            if Value mod Factor = 0 then
               return 0;
            end if;
            Result := -Result;
         end if;
      end loop;
      return Result;
   end Moebius;
   Line    : String (1..80);
   Pointer : Integer := 1;
begin
   for N in Half_Word range 1..199 loop
      Put (Line, Pointer, Moebius (N), 10, True, 3, Strings_Edit.Right);
      if Pointer > 68 then
         Put_Line (Line (1..Pointer - 1));
         Pointer := 1;
      end if;
   end loop;
   if Pointer > 1 then
      Put_Line (Line (1..Pointer - 1));
   end if;
end Moebius;
