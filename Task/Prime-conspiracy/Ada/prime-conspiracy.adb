with Ada.Text_IO;                 use Ada.Text_IO;
with Strings_Edit.Floats;         use Strings_Edit.Floats;
with Strings_Edit.Integers;       use Strings_Edit.Integers;
with Unbounded_Unsigneds;         use Unbounded_Unsigneds;
with Unbounded_Unsigneds.Primes;  use Unbounded_Unsigneds.Primes;

procedure Prime_Conspiracy is
   use Strings_Edit;

   subtype Digit is Half_Word range 0..9;
   Histogram : array (Digit, Digit) of Natural := (others => (others => 0));
   Line    : String (1..80);
   Pointer : Integer;
   Count   : Natural := 1;
   From    : Digit   := 2;
   To      : Digit;
   Prime   : Unbounded_Unsigned := Two;
begin
   loop
      Next_Prime (Prime, 10);
      exit when Prime >= 1_000_000;
      To := Prime mod 10;
      Histogram (From, To) := Histogram (From, To) + 1;
      From  := To;
      Count := Count + 1;
   end loop;
   Put_Line ("    ->0    ->1    ->2    ->3    ->4    ->5    ->6    ->7    ->8    ->9");
   for I in Histogram'Range (1) loop
      Pointer := 1;
      Put (Line, Pointer, Integer (I));
      Put (Line, Pointer, "->");
      for J in Histogram'Range (2) loop
         if Histogram (I, J) = 0 then
            Put (Line, Pointer, "       ");
         else
            Put
            (  Destination => Line,
               Pointer     => Pointer,
               Value       => Float (Histogram (I, J)) / Float (Count),
               AbsSmall    =>-5,
               Field       => 7,
               Justify     => Right
            );
         end if;
      end loop;
      Put_Line (Line (1..Pointer - 1));
   end loop;
end Prime_Conspiracy;
