with Ada.Text_IO;                 use Ada.Text_IO;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;
with Strings_Edit.Integers;       use Strings_Edit.Integers;

procedure Numbers_Whose_Count_Of_Divisors_Is_Prime is
   Limit   : constant Half_Word := 100_000;
   Counts  : array (1..Limit) of Half_Word := (others => 0);
   Found   : Natural := 0;
   Line    : String (1..80);
   Pointer : Integer := 1;
begin
   for I in 1..Limit - 1 loop
      declare
         J : Half_Word := I;
      begin
         while J < Limit loop
            Counts (J) := Counts (J) + 1;
            J := J + I;
         end loop;
      end;
   end loop;
   for I in 2..Sqrt (Limit) loop
      declare
         N : constant Half_Word := I * I;
      begin
         if Is_Prime (Counts (N)) = Prime then
            Found := Found + 1;
            Put
            (  Destination => Line,
               Pointer     => Pointer,
               Value       => Integer (N),
               Field       => 6,
               Justify     => Strings_Edit.Right
            );
            if Found mod 10 = 0 then
               Put_Line (Line (2..Pointer - 1));
               Pointer := 1;
            end if;
		  end if;
      end;
   end loop;
   if Pointer > 1 then
      Put_Line (Line (2..Pointer - 1));
   end if;
end Numbers_Whose_Count_Of_Divisors_Is_Prime;
