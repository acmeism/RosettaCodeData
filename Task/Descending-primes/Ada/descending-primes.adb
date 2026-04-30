with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;
with Strings_Edit.Integers;       use Strings_Edit.Integers;

procedure Descending_Primes is
   use Strings_Edit;
   Line    : String (1..90);
   Pointer : Integer := 1;

   procedure Check (Value, Digit : Half_Word; Length : Natural) is
      This : constant Half_Word := Value * 10;
   begin
      if Length = 0 then
         if Value > 1 and then Is_Prime (Value) = Prime then
            Put (Line, Pointer, Integer (Value), 10, False, 9, Right);
            if Pointer > 80 then
               Put_Line (Line (1..Pointer - 1));
               Pointer := 1;
            end if;
         end if;
      else
         for Next in 1..Digit - 1 loop
            Check (This + Next, Next, Length - 1);
         end loop;
      end if;
   end Check;
begin
   for Length in 1..9 loop
      Check (0, 10, Length);
   end loop;
   Put_Line (Line (1..Pointer - 1));
end Descending_Primes;
