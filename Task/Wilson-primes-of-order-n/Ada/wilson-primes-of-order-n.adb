with Ada.Text_IO;                 use Ada.Text_IO;
with Strings_Edit.Integers;       use Strings_Edit.Integers;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

with Strings_Edit.Unbounded_Unsigned_Edit;
use  Strings_Edit.Unbounded_Unsigned_Edit;

procedure Wilson_Primes is

   function Factorial (N : Half_Word) return Unbounded_Unsigned is
      Result : Unbounded_Unsigned := One;
   begin
      for I in 2..N loop
         Mul (Result, I);
      end loop;
      return Result;
   end Factorial;

   L : String (1..100) := (others => ' ');
   I : Integer := 1;

   procedure Check (P : Half_Word) is
      W : Unbounded_Unsigned := From_Half_Word (P);
   begin
      if Is_Prime (W, 10) = Prime then
         W := Square (W);
         for N in Half_Word range 1..11 loop
            if P >= N then
               if (Factorial (N - 1) * Factorial (P - N) + 2 * (N mod 2) - 1)
                  mod W = 0
               then
                  I := Integer (N - 1) * 5 + 1;
                  Put
                  (  Destination => L,
                     Pointer     => I,
                     Value       => Integer (P),
                     Field       => 5,
                     Justify     => Strings_Edit.Right,
                     Fill        => ' '
                  );
               end if;
            end if;
         end loop;
         if I > 1 then
            Put_Line (L (1..I - 1));
            for J in 1..I loop
               L (J) := ' ';
               I     := 1;
            end loop;
         end if;
      end if;
   end Check;
begin
   Put_Line ("    1    2    3    4    5    6    7    8    9   10   11");
   Put_Line ("-------------------------------------------------------");
   for I in Half_Word range 1..Half_Word'Last loop
      Check (I * 6 - 1);
      Check (I * 6 + 1);
      exit when I > 1834;
   end loop;
end Wilson_Primes;
